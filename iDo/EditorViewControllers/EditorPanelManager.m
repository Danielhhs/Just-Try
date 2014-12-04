//
//  EditorPanelHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelManager.h"
#import "ImageEditorPanelContainerViewController.h"
#import "TextEditorPanelContainerViewController.h"
#import "UIView+Snapshot.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "DrawingConstants.h"

#define EDITOR_PANEL_WIDTH 300

@interface EditorPanelManager()

@property (nonatomic, strong) ImageEditorPanelContainerViewController *imageEditor;
@property (nonatomic, strong) EditorPanelContainerViewController *currentEditor;
@property (nonatomic, strong) TextEditorPanelContainerViewController *textEditor;

@end

static EditorPanelManager *sharedInstance;

@implementation EditorPanelManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        _imageEditor = [self createImageEditorViewController];
        _textEditor = [self createTextEditorViewController];
    }
    return self;
}

+ (EditorPanelManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[EditorPanelManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Utility Methods

+ (CGRect) editorPanelFrameInView:(UIView *) parentView
{
    CGRect frame;
    frame.size.width = EDITOR_PANEL_WIDTH;
    frame.size.height = parentView.bounds.size.height;
    frame.origin.x = parentView.bounds.size.width - EDITOR_PANEL_WIDTH;
    frame.origin.y = [DrawingConstants topBarHeight];
    return frame;
}

+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView
{
    CGRect frame;
    frame.size.width = EDITOR_PANEL_WIDTH;
    frame.size.height = parentView.bounds.size.height;
    frame.origin.x = parentView.bounds.size.width;
    frame.origin.y = [DrawingConstants topBarHeight];
    return frame;
}

+ (CGFloat) currentEditorWidth
{
    return sharedInstance.currentEditor.view.frame.size.width;
}

- (ImageEditorPanelContainerViewController *) createImageEditorViewController
{
    return [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageEditorPanelContainerViewController"];
}

- (TextEditorPanelContainerViewController *) createTextEditorViewController
{
    return [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"TextEditorPanelContainerViewController"];
}

- (void) textViewDidSelectFont:(UIFont *)font
{
    if ([self.currentEditor isKindOfClass:[TextEditorPanelContainerViewController class]]) {
        [(TextEditorPanelContainerViewController *)self.currentEditor selectFont:font];
    }
}

#pragma mark - Presenting Editor Panels
- (void) showEditorPanelInViewController:(SlidesContainerViewController *)viewController
                          forContentView:(GenericContainerView *)contentView
{
    if (self.currentEditor) {
        [self switchCurrentEditoToEditorForView:contentView inViewController:viewController];
    } else {
        if ([contentView isKindOfClass:[ImageContainerView class]]) {
            [self showImageEditorInViewController:viewController attributes:[contentView attributes] target:contentView animated:YES];
        } else if ([contentView isKindOfClass:[TextContainerView class]]) {
            [self showTextEditorInViewController:viewController attributes:[contentView attributes] target:contentView animated:YES];
        }
    }
}


- (void) showEditorPanelInViewController:(SlidesContainerViewController *)viewController
                          forContentView:(GenericContainerView *)contentView
                                animated:(BOOL) animated
{
    if ([contentView isKindOfClass:[ImageContainerView class]]) {
        [self showImageEditorInViewController:viewController attributes:[contentView attributes] target:contentView animated:animated];
    } else if ([contentView isKindOfClass:[TextContainerView class]]) {
        [self showTextEditorInViewController:viewController attributes:[contentView attributes] target:contentView animated:animated];
    }
}

- (void) showImageEditorInViewController:(SlidesContainerViewController *)viewController
                              attributes:(NSMutableDictionary *)attributes
                                  target:(id<OperationTarget>) target
                                animated:(BOOL) animated
{
    self.currentEditor = self.imageEditor;
    [self showCurrentEditorInViewController:viewController animated:animated];
    self.imageEditor.target = target;
    self.imageEditor.delegate = viewController.editorViewController;
    [self.imageEditor applyAttributes:attributes];
}

- (void) showTextEditorInViewController:(SlidesContainerViewController *)viewController
                             attributes:(NSMutableDictionary *)attributes
                                 target:(id<OperationTarget>) target
                               animated:(BOOL) animated
{
    self.currentEditor = self.textEditor;
    [self showCurrentEditorInViewController:viewController animated:animated];
    self.textEditor.target  = target;
    self.textEditor.delegate = viewController.editorViewController;
    [self.textEditor applyAttributes:attributes];
}

- (void) showCurrentEditorInViewController:(SlidesContainerViewController *) viewController animated:(BOOL) animated
{
    [viewController addChildViewController:self.currentEditor];
    self.currentEditor.view.frame = [EditorPanelManager editorPanelFrameOutOfView:viewController.view];
    [viewController.view addSubview:self.currentEditor.view];
    [self.currentEditor didMoveToParentViewController:viewController];
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.currentEditor.view.frame = [EditorPanelManager editorPanelFrameInView:viewController.view];
            [viewController adjustCanvasSizeAndPosition];
        } completion:^(BOOL finished) {
        }];
    } else {
        self.currentEditor.view.frame = [EditorPanelManager editorPanelFrameInView:viewController.view];
    }
}

#pragma mark - Dismiss Editor Panels
- (void) dismissAllEditorPanelsFromViewController:(SlidesContainerViewController *) viewController
{
    EditorPanelContainerViewController *animationVC = nil;
    if (self.currentEditor == nil) return;
    if ([self.currentEditor isKindOfClass:[ImageEditorPanelContainerViewController class]]) {
        animationVC = [self createImageEditorViewController];
    } else if ([self.currentEditor isKindOfClass:[TextEditorPanelContainerViewController class]]) {
        animationVC = [self createTextEditorViewController];
    }
    [viewController addChildViewController:animationVC];
    animationVC.view.frame = self.currentEditor.view.frame;
    
    [self.currentEditor willMoveToParentViewController:nil];
    [self.currentEditor.view removeFromSuperview];
    [self.currentEditor removeFromParentViewController];
    self.currentEditor = nil;
    
    [viewController.view addSubview:animationVC.view];
    [animationVC didMoveToParentViewController:viewController];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        animationVC.view.frame = [EditorPanelManager editorPanelFrameOutOfView:viewController.view];
        [viewController adjustCanvasSizeAndPosition];
    } completion:^(BOOL finished) {
        [animationVC willMoveToParentViewController:nil];
        [animationVC.view removeFromSuperview];
        [animationVC removeFromParentViewController];
    }];
}

- (void) switchCurrentEditoToEditorForView:(GenericContainerView *) content inViewController:(SlidesContainerViewController *) viewController
{
    if (self.currentEditor) {
        [self.currentEditor willMoveToParentViewController:nil];
        [self.currentEditor.view removeFromSuperview];
        [self.currentEditor removeFromParentViewController];
        
        [self showEditorPanelInViewController:viewController forContentView:content animated:NO];
    }
}

- (void) handleContentViewDidFinishChanging
{
    [self.currentEditor hideTooltip];
}

- (void) contentViewDidSelectRange:(NSRange)range
{
    if ([self.currentEditor isKindOfClass:[TextEditorPanelContainerViewController class]]) {
        TextEditorPanelContainerViewController *textEditor = (TextEditorPanelContainerViewController *)self.currentEditor;
        [textEditor updateFontPickerByRange:range];
    }
}

- (void) selectTextBasicEditorPanel
{
    if ([self.currentEditor isKindOfClass:[TextEditorPanelContainerViewController class]]) {
        TextEditorPanelContainerViewController *textEditor = (TextEditorPanelContainerViewController *)self.currentEditor;
        [textEditor selectBasicEditor];
    }
}


@end
