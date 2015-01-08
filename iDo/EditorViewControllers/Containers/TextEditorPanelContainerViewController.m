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
    self.basicEditor = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"TextBasicEditorPanelViewController"];
    self.basicEditor.delegate = self;
    self.styleEditor = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"TextStyleEditorContentViewController"];
    self.styleEditor.delegate = self;
    self.borderEditor = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"TextStyleEditorContentViewController"];
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
    self.textEditorSelector.selectedSegmentIndex = BASIC_EDITOR_INDEX;
    [self removeSubViewController:self.styleEditor];
    [self removeSubViewController:self.borderEditor];
    [self addSubViewController:self.basicEditor];
}

- (void) selectStyleEditor
{
    [self removeSubViewController:self.basicEditor];
    [self removeSubViewController:self.borderEditor];
    [self addSubViewController:self.styleEditor];
    [self.delegate textEditorDidSelectNonBasicEditor:self];
}

- (void) selectBorderEditor
{
    [self removeSubViewController:self.basicEditor];
    [self removeSubViewController:self.styleEditor];
    [self addSubViewController:self.borderEditor];
    [self.delegate textEditorDidSelectNonBasicEditor:self];
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

- (void) setTarget:(id<OperationTarget>)target
{
    self.basicEditor.target = target;
    self.borderEditor.target = target;
    self.styleEditor.target = target;
}

#pragma mark - BasicTextEditorPanelViewControllerDelegate
- (void) textAttributes:(NSDictionary *)textAttributes didChangeFromTextEditor:(TextBasicEditorPanelViewController *)textEditor
{
    [self.delegate textAttributes:textAttributes didChangeFromTextEditor:self];
}

- (void) showColorPickerForColor:(UIColor *) color;
{
    [self.delegate showColorPickerForColor:color];
}

- (void) changeTextContainerBackgroundColor:(UIColor *) color
{
    [self.delegate changeTextContainerBackgroundColor:color];
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(GenericContentDTO *)attributes
{
    [self.basicEditor applyAttributes:attributes];
    [self.styleEditor applyAttributes:attributes];
    [self.borderEditor applyAttributes:attributes];
}

- (void) updateFontPickerByRange:(NSRange)range
{
    [self.basicEditor updateFontPickerByRange:range];
}

- (void) selectFont:(UIFont *)font
{
    [self.basicEditor selectFont:font];
}

@end
