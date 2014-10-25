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

#define THUMB_WIDTH_HALF 15

@interface EditorPanelViewController ()<SliderWithToolTipDelegate>
@property (weak, nonatomic) IBOutlet EditorButtonView *addReflectionView;
@property (weak, nonatomic) IBOutlet EditorButtonView *addShadowView;
@property (weak, nonatomic) IBOutlet TooltipView *tooltipView;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *alphaSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *sizeSlider;
@property (weak, nonatomic) IBOutlet SliderWithTooltip *rotationSlider;
@end

@implementation EditorPanelViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapToAddReflection = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addReflection:)];
    [self.addReflectionView addGestureRecognizer:tapToAddReflection];
    UITapGestureRecognizer *tapToAddShadow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addShadow:)];
    [self.addShadowView addGestureRecognizer:tapToAddShadow];
    self.rotationSlider.delegate = self;
    self.alphaSlider.delegate = self;
    self.sizeSlider.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTap:(id)sender {
}

- (IBAction)rotationValueChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    [self.delegate editorPanelViewController:self didChangeAttributes:@{[GenericContainerViewHelper rotationKey] : @(sender.value)}];
}

- (void)restore {
    self.rotationSlider.value = 0;
    [self.delegate restoreFromEditorPanelViewController:self];
}

- (void) applyAttribute:(NSDictionary *)attributes
{
    NSNumber *rotation = [attributes objectForKey:[GenericContainerViewHelper rotationKey]];
    if (rotation) {
        CGFloat angle = [rotation doubleValue] / M_PI * ANGELS_PER_PI;
        self.rotationSlider.value = angle;
        [self updateTooltipViewFromSender:self.rotationSlider];
    }
}

- (IBAction)alphaChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    NSString *changedKey;
    if (self.addReflectionView.selected) {
        changedKey = [GenericContainerViewHelper reflectionAlphaKey];
    } else {
        changedKey = [GenericContainerViewHelper shadowAlphaKey];
    }
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}

- (IBAction)sizeChanged:(UISlider *)sender {
    [self updateTooltipViewFromSender:sender];
    NSString *changedKey;
    if (self.addReflectionView.selected) {
        changedKey = [GenericContainerViewHelper reflectionSizeKey];
    } else {
        changedKey = [GenericContainerViewHelper shadowSizeKey];
    }
    [self.delegate editorPanelViewController:self didChangeAttributes:@{changedKey : @(sender.value)}];
}


- (void) addReflection:(UITapGestureRecognizer *) gesture
{
    self.addReflectionView.selected = !self.addReflectionView.selected;
    self.addShadowView.selected = NO;
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [GenericContainerViewHelper reflectionKey] : @(self.addReflectionView.selected),
                                                                        [GenericContainerViewHelper shadowKey] : @(NO)
                                                                        }];
}

- (void) addShadow:(UITapGestureRecognizer *) gesture
{
    self.addShadowView.selected = !self.addShadowView.selected;
    self.addReflectionView.selected = NO;
    [self.delegate editorPanelViewController:self didChangeAttributes:@{
                                                                        [GenericContainerViewHelper shadowKey] : @(self.addShadowView.selected),
                                                                        [GenericContainerViewHelper reflectionKey] : @(NO)
                                                                        }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
