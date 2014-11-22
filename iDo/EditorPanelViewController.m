//
//  EditorPanelViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelViewController.h"
#import "ImageHelper.h"
#import "EditorPanelManager.h"
#import "UIView+Snapshot.h"
#import "EditorButtonView.h"
#import "TooltipView.h"
#import "SliderWithTooltip.h"
#import "KeyConstants.h"
#import "CompoundOperation.h"
#import "UndoManager.h"
#import "ReflectionShadowTypeCell.h"
#import "ReflectionHelper.h"
#import "ShadowHelper.h"

#define THUMB_WIDTH_HALF 15

@interface EditorPanelViewController ()<SliderWithToolTipDelegate, OperationTarget, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet EditorButtonView *addReflectionView;
@property (weak, nonatomic) IBOutlet EditorButtonView *addShadowView;
@property (weak, nonatomic) IBOutlet TooltipView *tooltipView;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *alphaSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *sizeSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *viewOpacitySlider;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (weak, nonatomic) IBOutlet UICollectionView *typeSelector;
@property (nonatomic, strong) NSArray *reflectionShadowTypes;
@end

@implementation EditorPanelViewController

#pragma mark - Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapToAddReflection = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reflectionStatusChanged:)];
    [self.addReflectionView addGestureRecognizer:tapToAddReflection];
    self.addReflectionView.key = [KeyConstants reflectionKey];
    UITapGestureRecognizer *tapToAddShadow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowStatusChanged:)];
    [self.addShadowView addGestureRecognizer:tapToAddShadow];
    self.addShadowView.key = [KeyConstants shadowKey];
    self.alphaSlider.delegate = self;
    self.sizeSlider.delegate = self;
    self.viewOpacitySlider.delegate = self;
    self.viewOpacitySlider.key = [KeyConstants viewOpacityKey];
    [self.typeSelector registerClass:[ReflectionShadowTypeCell class] forCellWithReuseIdentifier:@"typeSelectorCell"];
    self.typeSelector.dataSource = self;
    self.typeSelector.delegate = self;
    self.attributes = [NSMutableDictionary dictionary];
}

- (void) setTarget:(id<OperationTarget>)target
{
    _target = target;
    self.alphaSlider.target = target;
    self.sizeSlider.target = target;
    self.viewOpacitySlider.target = target;
}

#pragma mark - User Interaction 
- (IBAction)handleTap:(id)sender {
}

- (void) applyAttributes:(NSDictionary *)attributes
{
    [GenericContainerViewHelper mergeChangedAttributes:attributes withFullAttributes:self.attributes];
    NSNumber *reflection = attributes[[KeyConstants reflectionKey]];
    if (reflection) {
        self.addReflectionView.selected = [reflection boolValue];
    }
    NSNumber *shadow = attributes[[KeyConstants shadowKey]];
    if (shadow) {
        self.addShadowView.selected = [shadow boolValue];
    }
    [self updateSlidersGeneratingOperations:NO];
}

- (IBAction)alphaChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    NSString *changedKey;
    if (self.addReflectionView.selected) {
        changedKey = [KeyConstants reflectionAlphaKey];
    } else {
        changedKey = [KeyConstants shadowAlphaKey];
    }
    [self.attributes setValue:@(sender.value) forKey:changedKey];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}

- (IBAction)sizeChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    NSString *changedKey;
    if (self.addReflectionView.selected) {
        changedKey = [KeyConstants reflectionSizeKey];
    } else {
        changedKey = [KeyConstants shadowSizeKey];
    }
    [self.attributes setValue:@(sender.value) forKey:changedKey];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}

- (IBAction)viewOpacityChanged:(SliderWithTooltip *)sender {
    [self updateTooltipViewFromSender:sender];
    [self.attributes setValue:@(sender.value) forKey:[KeyConstants viewOpacityKey]];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{[KeyConstants viewOpacityKey] : @(sender.value)}];
}

- (void) reflectionStatusChanged:(UITapGestureRecognizer *) gesture
{
    [self switchFromView:self.addShadowView toView:self.addReflectionView];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [KeyConstants reflectionKey] : @(self.addReflectionView.selected),
                                                                        [KeyConstants shadowKey] : @(NO)
                                                                        }];
}

- (void) shadowStatusChanged:(UITapGestureRecognizer *) gesture
{
    [self switchFromView:self.addReflectionView toView:self.addShadowView];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [KeyConstants shadowKey] : @(self.addShadowView.selected),
                                                                        [KeyConstants reflectionKey] : @(NO)
                                                                        }];
}

- (void) switchFromView:(EditorButtonView *)fromView toView:(EditorButtonView *) toView
{
    SimpleOperation *toViewOperation = [[SimpleOperation alloc] initWithTargets:@[self.target, self] key:toView.key fromValue:@(toView.selected)];
    toView.selected = !toView.selected;
    toViewOperation.toValue = @(toView.selected);
    SimpleOperation *fromViewOperation = [[SimpleOperation alloc] initWithTargets:@[self.target, self] key:fromView.key fromValue:@(fromView.selected)];
    fromView.selected = NO;
    fromViewOperation.toValue = @(NO);
    [self updateReflectionShadowStatus];
    NSArray * sliderOperations = [self updateSlidersGeneratingOperations:YES];
    NSMutableArray *operations = [NSMutableArray arrayWithArray:sliderOperations];
    [operations addObject:toViewOperation];
    [operations addObject:fromViewOperation];
    CompoundOperation *compoundOperation = [[CompoundOperation alloc] initWithOperations:operations];
    [[UndoManager sharedManager] pushOperation:compoundOperation];
}

- (void) updateReflectionShadowStatus
{
    [self.attributes setValue:@(self.addReflectionView.selected) forKey:[KeyConstants reflectionKey]];
    [self.attributes setValue:@(self.addShadowView.selected) forKey:[KeyConstants shadowKey]];
}

- (NSArray *) updateSlidersGeneratingOperations:(BOOL) generateOperations
{
    self.sizeSlider.enabled = YES;
    self.alphaSlider.enabled = YES;
    SimpleOperation *alphaOperation, *sizeOperation, *typeOperation;
    if (self.addReflectionView.selected) {
        self.reflectionShadowTypes = [ReflectionHelper reflectionTypes];
        [self.typeSelector reloadData];
        NSNumber *reflectionAlpha = self.attributes[[KeyConstants reflectionAlphaKey]];
        if (reflectionAlpha) {
            alphaOperation = [self.alphaSlider setValue:[reflectionAlpha floatValue] generateOperations:generateOperations];
        }
        NSNumber *reflectionSize = self.attributes[[KeyConstants reflectionSizeKey]];
        if (reflectionSize) {
            sizeOperation = [self.sizeSlider setValue:[reflectionSize floatValue] generateOperations:generateOperations];
        }
        self.alphaSlider.key = [KeyConstants reflectionAlphaKey];
        self.sizeSlider.key = [KeyConstants reflectionSizeKey];
    } else if (self.addShadowView.selected) {
        self.reflectionShadowTypes = [ShadowHelper shadowTypes];
        [self.typeSelector reloadData];
        NSNumber *shadowAlpha = self.attributes[[KeyConstants shadowAlphaKey]];
        if (shadowAlpha) {
            alphaOperation = [self.alphaSlider setValue:[shadowAlpha floatValue] generateOperations:generateOperations];
        }
        NSNumber *shadowSize = self.attributes[[KeyConstants shadowSizeKey]];
        if (shadowSize) {
            sizeOperation = [self.sizeSlider setValue:[shadowSize doubleValue] generateOperations:generateOperations];
        }
        self.alphaSlider.key = [KeyConstants shadowAlphaKey];
        self.sizeSlider.key = [KeyConstants shadowSizeKey];
    } else {
        self.sizeSlider.enabled = NO;
        self.alphaSlider.enabled = NO;
        self.typeSelector.userInteractionEnabled = NO;
        return nil;
    }
    if (generateOperations == YES) {
        return @[alphaOperation, sizeOperation];
    }
    return nil;
}

#pragma mark - Tooltip Management

- (void) updateTooltipViewFromSender:(UISlider *) sender
{
    CGRect trackRect = [sender trackRectForBounds:sender.bounds];
    CGRect thumbRect = [sender thumbRectForBounds:[sender bounds] trackRect:trackRect value:sender.value];
    CGPoint position = [self.view convertPoint:thumbRect.origin fromView:sender];
    self.tooltipView.hidden = NO;
    self.tooltipView.toolTipText = [NSString stringWithFormat:@"%3.2f", sender.value];
    self.tooltipView.center = [self tooltipCenterFromThumbPosition:position];
}

- (CGPoint) tooltipCenterFromThumbPosition:(CGPoint) position
{
    CGPoint center;
    center.x = position.x + THUMB_WIDTH_HALF;
    center.y = position.y - self.tooltipView.frame.size.height / 2;
    return center;
}

- (IBAction)hideTooltip
{
    self.tooltipView.hidden = YES;
}

- (void) touchDidEndInSlider:(SliderWithTooltip *)slider
{
    self.tooltipView.hidden = YES;
}

#pragma mark - Operation Target
- (void) performOperation:(SimpleOperation *)operation
{
    [self applyAttributes:@{operation.key : operation.toValue}];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.reflectionShadowTypes count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"typeSelectorCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ReflectionShadowTypeCell class]]) {
        ReflectionShadowTypeCell *typeCell = (ReflectionShadowTypeCell *) cell;
        ReflectionShadowType *type = self.reflectionShadowTypes[indexPath.row];
        typeCell.text = type.desc;
        typeCell.type = type.type;
        typeCell.hidden = NO;
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReflectionShadowTypeCell *cell = (ReflectionShadowTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *key = self.addReflectionView.selected ? [KeyConstants reflectionTypeKey] : [KeyConstants shadowTypeKey];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{key : @(cell.type)}];
}

@end
