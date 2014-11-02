//
//  TextEditorPanelContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/1/14.
//  Copyright (c) 2014 ;. All rights reserved.
//

#import "TextEditorPanelContainerViewController.h"

#import "TextBasicEditorPanelViewController.h"
#import "TextStyleEditorContentViewController.h"
#import "BordersContentViewController.h"

#define BASIC_EDITOR_INDEX 0
#define STYLE_EDITOR_INDEX 1
#define BORDER_EDITOR_INDEX 2

@interface TextEditorPanelContainerViewController ()<BasicTextEditorPanelViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *textEditorSelector;
@property (nonatomic, strong) TextBasicEditorPanelViewController *basicEditor;
@property (nonatomic, strong) TextStyleEditorContentViewController *styleEditor;
@property (nonatomic, strong) BordersContentViewController *borderEditor;

@end

@implementation TextEditorPanelContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.basicEditor = [[TextBasicEditorPanelViewController alloc] initWithNibName:@"TextBasicEditorPanelViewController" bundle:[NSBundle mainBundle]];
    self.basicEditor.delegate = self;
    self.styleEditor = [[TextStyleEditorContentViewController alloc] initWithNibName:@"TextStyleEditorContentViewController" bundle:[NSBundle mainBundle]];
    self.styleEditor.delegate = self;
    self.borderEditor = [[BordersContentViewController alloc] initWithNibName:@"TextStyleEditorContentViewController" bundle:[NSBundle mainBundle]];
    self.borderEditor.delegate = self;
    [self selectBasicEditor];
}

- (IBAction)selectTextEditor:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == BASIC_EDITOR_INDEX) {
        [self selectBasicEditor];
    } else if (sender.selectedSegmentIndex == STYLE_EDITOR_INDEX) {
        [self selectStyleEditor];
    } else if (sender.selectedSegmentIndex == BORDER_EDITOR_INDEX) {
        [self selectBorderEditor];
    }
}

- (void) selectBasicEditor
{
    [self removeSubViewController:self.styleEditor];
    [self removeSubViewController:self.borderEditor];
    [self addSubViewController:self.basicEditor];
}

- (void) selectStyleEditor
{
    [self removeSubViewController:self.basicEditor];
    [self removeSubViewController:self.borderEditor];
    [self addSubViewController:self.styleEditor];
}

- (void) selectBorderEditor
{
    [self removeSubViewController:self.basicEditor];
    [self removeSubViewController:self.styleEditor];
    [self addSubViewController:self.borderEditor];
}

- (void) removeSubViewController:(UIViewController *) viewController
{
    if (viewController) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}

- (void) addSubViewController:(UIViewController *) viewController
{
    [self addChildViewController:viewController];
    viewController.view.frame = [self contentFrameFromYPosition:CGRectGetMaxY(self.textEditorSelector.frame)];
    [self.backgroundView.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

#pragma mark - BasicTextEditorPanelViewControllerDelegate
- (void) textAttributes:(NSDictionary *)textAttributes didChangeFromTextEditor:(TextBasicEditorPanelViewController *)textEditor
{
    [self.delegate textAttributes:textAttributes didChangeFromTextEditor:self];
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    [self.basicEditor applyAttributes:attributes];
    [self.styleEditor applyAttributes:attributes];
    [self.borderEditor applyAttributes:attributes];
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
