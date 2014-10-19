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


#define EDITOR_PANEL_WIDTH 300

@interface EditorPanelManager()

@property (nonatomic, strong) ImageEditorPanelViewController *imageEditor;

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

#pragma mark - Image Editor Panel Management

- (void) showImageEditorInViewController:(UIViewController *)viewController
                        imageInformation:(ImageItem *)imageItem
{
    self.imageEditor.backgroundImage = [viewController.view snapshotInRect:[EditorPanelManager editorPanelFrameInView:viewController.view]];
    [viewController addChildViewController:self.imageEditor];
    self.imageEditor.view.frame = [EditorPanelManager editorPanelFrameOutOfView:viewController.view];
    [viewController.view addSubview:self.imageEditor.view];
    [self.imageEditor didMoveToParentViewController:viewController];
}

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

#pragma mark - Dismiss Editor Panels
- (void) dismissAllEditorPanels
{
    [self.imageEditor willMoveToParentViewController:nil];
    [self.imageEditor.view removeFromSuperview];
    [self.imageEditor removeFromParentViewController];
}


@end
