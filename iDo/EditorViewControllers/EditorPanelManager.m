//
//  EditorPanelHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelManager.h"
#import "ImageEditorPanelViewController.h"
#import "UIView+Snapshot.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"

#define EDITOR_PANEL_WIDTH 300

@interface EditorPanelManager()

@property (nonatomic, strong) ImageEditorPanelViewController *imageEditor;
@property (atomic) BOOL animationFinished;

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
        _animationFinished = YES;
        _imageEditor = [[ImageEditorPanelViewController alloc] initWithNibName:@"ImageEditorPanelViewController" bundle:[NSBundle mainBundle]];
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
    frame.origin.y = 0;
    return frame;
}

+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView
{
    CGRect frame;
    frame.size.width = EDITOR_PANEL_WIDTH;
    frame.size.height = parentView.bounds.size.height;
    frame.origin.x = parentView.bounds.size.width;
    frame.origin.y = 0;
    return frame;
}

#pragma mark - Presenting Editor Panels
- (void) showEditorPanelInViewController:(UIViewController *)viewController
                          forContentView:(GenericContainerView *)contentView
{
    if ([contentView isKindOfClass:[ImageContainerView class]]) {
        [self showImageEditorInViewController:viewController imageInformation:nil];
    } else if ([contentView isKindOfClass:[TextContainerView class]]) {
        [self showTextEditorInViewController:viewController imageInformation:nil];
    }
}

- (void) showImageEditorInViewController:(UIViewController *)viewController
                        imageInformation:(ImageItem *)imageItem
{
    self.imageEditor.backgroundImage = [viewController.view snapshotInRect:[EditorPanelManager editorPanelFrameInView:viewController.view]];
    [viewController addChildViewController:self.imageEditor];
    self.imageEditor.view.frame = [EditorPanelManager editorPanelFrameOutOfView:viewController.view];
    [viewController.view addSubview:self.imageEditor.view];
    [self.imageEditor didMoveToParentViewController:viewController];
    self.animationFinished = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.imageEditor.view.frame = [EditorPanelManager editorPanelFrameInView:viewController.view];
    } completion:^(BOOL finished) {
    }];
}

- (void) showTextEditorInViewController:(UIViewController *)viewController
                       imageInformation:(ContentItem *)textItem
{
    
}

#pragma mark - Dismiss Editor Panels
- (void) dismissAllEditorPanelsFromViewController:(UIViewController *) viewController
{
    UIView *animationView = [[UIView alloc] initWithFrame:self.imageEditor.view.frame];
    animationView.layer.contents = (__bridge id)[self.imageEditor.view snapshotInRect:self.imageEditor.view.bounds].CGImage;
    [viewController.view addSubview:animationView];
    [self.imageEditor willMoveToParentViewController:nil];
    [self.imageEditor.view removeFromSuperview];
    [self.imageEditor removeFromParentViewController];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        animationView.frame = [EditorPanelManager editorPanelFrameOutOfView:viewController.view];
    } completion:^(BOOL finished) {
    }];
}


@end
