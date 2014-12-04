//
//  ImageEditorPanelContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageEditorPanelContainerViewController.h"
#import "BasicImageEditorContentViewController.h"
#import "BordersContentViewController.h"

@interface ImageEditorPanelContainerViewController ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *panelSelector;

@property (nonatomic, strong) BasicImageEditorContentViewController *basicEditor;
@property (nonatomic, strong) BordersContentViewController *bordersEditor;

@end

#define BASIC_SEGMENT_INDEX 0
#define BORDERS_SEGMENT_INDEX 1

@implementation ImageEditorPanelContainerViewController

#pragma mark - Memory Management
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void) setup
{
    [self setupImageBasicEditor];
    [self setupImageBorderEditor];
    [self selectImageBasicEditor];
}

- (void) setupImageBasicEditor
{
    self.basicEditor = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"BasicImageEditorContentViewController"];
    self.basicEditor.delegate = self;
}

- (void) setupImageBorderEditor
{
    self.bordersEditor = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"BordersContentViewController"];
    self.bordersEditor.delegate = self;
}

- (void) setTarget:(id<OperationTarget>)target
{
    self.basicEditor.target = target;
    self.bordersEditor.target = target;
}

#pragma mark - User Interaction
- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == BASIC_SEGMENT_INDEX) {
        [self selectImageBasicEditor];
    } else if (sender.selectedSegmentIndex == BORDERS_SEGMENT_INDEX) {
        [self selectImageBordersEditor];
    }
}
- (void) selectImageBasicEditor
{
    if (self.bordersEditor) {
        [self.bordersEditor willMoveToParentViewController:nil];
        [self.bordersEditor.view removeFromSuperview];
        [self.bordersEditor removeFromParentViewController];
    }
    
    [self addChildViewController:self.basicEditor];
    self.basicEditor.view.frame = [self contentFrameFromYPosition:CGRectGetMaxY(self.panelSelector.frame)];
    [self.backgroundView.contentView addSubview:self.basicEditor.view];
    [self.basicEditor didMoveToParentViewController:self];
}

- (void) selectImageBordersEditor
{
    [self.basicEditor willMoveToParentViewController:nil];
    [self.basicEditor.view removeFromSuperview];
    [self.basicEditor removeFromParentViewController];
    
    [self addChildViewController:self.bordersEditor];
    self.bordersEditor.view.frame = [self contentFrameFromYPosition:CGRectGetMaxY(self.panelSelector.frame)];
    [self.backgroundView.contentView addSubview:self.bordersEditor.view];
    [self.bordersEditor didMoveToParentViewController:self];
}

#pragma mark - Override Superview Methods
- (void) hideTooltip
{
    [self.basicEditor hideTooltip];
    [self.bordersEditor hideTooltip];
}

- (void) applyAttributes:(NSMutableDictionary *)attributes
{
    [self.basicEditor applyAttributes:attributes];
    [self.bordersEditor applyAttributes:attributes];
}

@end
