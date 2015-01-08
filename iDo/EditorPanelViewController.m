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
#import "ShadowHelper.h"
#import "ShadowType.h"
#import "OperationHelper.h"

#define THUMB_WIDTH_HALF 15

@interface EditorPanelViewController ()<SliderWithToolTipDelegate, OperationTarget, UICollectionViewDataSource, UICollectionViewDelegate, ReflectionShadowCellDelegate>
@property (weak, nonatomic) IBOutlet EditorButtonView *addReflectionView;
@property (weak, nonatomic) IBOutlet EditorButtonView *addShadowView;
@property (weak, nonatomic) IBOutlet TooltipView *tooltipView;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *alphaSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *sizeSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *viewOpacitySlider;
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
    self.attributes = [[GenericContentDTO alloc] init];
    self.reflectionShadowTypes = [ShadowHelper shadowTypes];
    [self.typeSelector reloadData];
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

- (void) applyAttributes:(GenericContentDTO *)attributes
{
    self.attributes = attributes;
    [self applyContentAttributes:attributes];
}

- (void) applyContentAttributes:(GenericContentDTO *) attributes
{
    self.addReflectionView.selected = attributes.reflection;
    self.addShadowView.selected = attributes.shadow;
    [self updateSlidersGeneratingOperations:NO];
}

- (void) applyUndoRedoAttributes:(NSDictionary *)attributes {
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
        self.attributes.reflectionAlpha = sender.value;
    } else {
        changedKey = [KeyConstants shadowAlphaKey];
        self.attributes.shadowAlpha = sender.value;
    }
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}

- (IBAction)sizeChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    NSString *changedKey;
    if (self.addReflectionView.selected) {
        changedKey = [KeyConstants reflectionSizeKey];
        self.attributes.reflectionSize = sender.value;
    } else {
        changedKey = [KeyConstants shadowSizeKey];
        self.attributes.shadowSize = sender.value;
    }
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}

- (IBAction)viewOpacityChanged:(SliderWithTooltip *)sender {
    [self updateTooltipViewFromSender:sender];
    self.attributes.opacity = sender.value;
    [self.delegate editorPanelViewController:self didChangeAttributes:@{[KeyConstants viewOpacityKey] : @(sender.value)}];
}

- (void) reflectionStatusChanged:(UITapGestureRecognizer *) gesture
{
    [self switchFromView:self.addShadowView toView:self.addReflectionView];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [KeyConstants reflectionKey] : @(self.addReflectionView.selected),
                                                                        [KeyConstants shadowKey] : @(NO),
                                                                        }];
}

- (void) shadowStatusChanged:(UITapGestureRecognizer *) gesture
{
    [self switchFromView:self.addReflectionView toView:self.addShadowView];
    ContentViewShadowType type = self.addShadowView.selected ? ContentViewShadowTypeStereo : ContentViewShadowTypeNone;
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [KeyConstants shadowKey] : @(self.addShadowView.selected),
                                                                        [KeyConstants reflectionKey] : @(NO),
                                                                        [KeyConstants shadowTypeKey] : @(type)
                                                                        }];
}

- (void) switchFromView:(EditorButtonView *)fromView toView:(EditorButtonView *) toView
{
    SimpleOperation *toViewOperation = [OperationHelper simpleOperatioWithTargets:@[self.target, self] key:toView.key fromValue:@(toView.selected) toValue:@(!toView.selected)];
    toView.selected = !toView.selected;
    SimpleOperation *fromViewOperation = [OperationHelper simpleOperatioWithTargets:@[self.target, self] key:fromView.key fromValue:@(fromView.selected) toValue:@(NO)];
    fromView.selected = NO;
    [self updateReflectionShadowStatus];
    NSArray * sliderOperations = [self updateSlidersGeneratingOperations:YES];
    NSMutableArray *operations = [NSMutableArray arrayWithArray:sliderOperations];
    [operations addObject:toViewOperation];
    [operations addObject:fromViewOperation];
    [OperationHelper pushCompoundOperationWithSimpleOperations:operations];
}

- (void) updateReflectionShadowStatus
{
    self.attributes.reflection = self.addReflectionView.selected;
    self.attributes.shadow = self.addShadowView.selected;
}

- (NSArray *) updateSlidersGeneratingOperations:(BOOL) generateOperations
{
    self.sizeSlider.enabled = YES;
    self.alphaSlider.enabled = YES;
    self.typeSelector.userInteractionEnabled = YES;
    SimpleOperation *alphaOperation, *sizeOperation;
    if (self.addReflectionView.selected) {
        self.typeSelector.hidden = YES;
        CGFloat reflectionAlpha = self.attributes.reflectionAlpha;
        if (reflectionAlpha >= 0) {
            alphaOperation = [self.alphaSlider setValue:reflectionAlpha generateOperations:generateOperations];
        }
        CGFloat reflectionSize = self.attributes.reflectionSize;
        if (reflectionSize >= 0) {
            sizeOperation = [self.sizeSlider setValue:reflectionSize generateOperations:generateOperations];
        }
        self.alphaSlider.key = [KeyConstants reflectionAlphaKey];
        self.sizeSlider.key = [KeyConstants reflectionSizeKey];
    } else if (self.addShadowView.selected) {
        self.typeSelector.hidden = NO;
        CGFloat shadowAlpha = self.attributes.shadowAlpha;
        if (shadowAlpha >= 0) {
            alphaOperation = [self.alphaSlider setValue:shadowAlpha generateOperations:generateOperations];
        }
        CGFloat shadowSize = self.attributes.shadowSize;
        if (shadowSize >= 0) {
            sizeOperation = [self.sizeSlider setValue:shadowSize generateOperations:generateOperations];
        }
        self.alphaSlider.key = [KeyConstants shadowAlphaKey];
        self.sizeSlider.key = [KeyConstants shadowSizeKey];
    } else {
        self.sizeSlider.enabled = NO;
        self.alphaSlider.enabled = NO;
        self.typeSelector.hidden = YES;
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
    [self applyUndoRedoAttributes:@{operation.key : operation.toValue}];
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
        ShadowType *type = self.reflectionShadowTypes[indexPath.row];
        typeCell.text = type.desc;
        typeCell.type = type.type;
        typeCell.delegate = self;
    }
    
    return cell;
}

#pragma mark - ReflectionShadowTypeCellDelegate
- (void) cellDidTapped:(ReflectionShadowTypeCell *)cell
{
    NSString *key = self.addReflectionView.selected ? [KeyConstants reflectionTypeKey] : [KeyConstants shadowTypeKey];
    [OperationHelper pushSimpleOperationWithTargets:@[self, self.target] key:key fromValue:@(self.attributes.shadowType) toValue:@(cell.type)];
    [self.attributes setValue:@(cell.type) forKey:key];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{key : @(cell.type)}];
}

@end
