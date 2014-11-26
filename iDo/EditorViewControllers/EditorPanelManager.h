//
//  EditorPanelHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerView.h"
#import "SlidesContainerViewController.h"

@interface EditorPanelManager : NSObject

+ (EditorPanelManager *) sharedManager;

- (void) showEditorPanelInViewController:(SlidesContainerViewController *) viewController
                          forContentView:(GenericContainerView *)contentView;

- (void) showImageEditorInViewController:(SlidesContainerViewController *) viewController
                              attributes:(NSDictionary *) imageItem
                                  target:(id<OperationTarget>)target
                                animated:(BOOL) animated;
- (void) showTextEditorInViewController:(SlidesContainerViewController *) viewController
                             attributes:(NSDictionary *) imageItem
                                 target:(id<OperationTarget>)target
                               animated:(BOOL) animated;

- (void) switchCurrentEditoToEditorForView:(GenericContainerView *) content inViewController:(SlidesContainerViewController *) viewController;

- (void) dismissAllEditorPanelsFromViewController:(SlidesContainerViewController *) viewController;

- (void) makeCurrentEditorApplyChanges:(NSDictionary *) attributes;

- (void) handleContentViewDidFinishChanging;

- (void) contentViewDidSelectRange:(NSRange) range;

- (void) selectTextBasicEditorPanel;

+ (CGRect) editorPanelFrameInView:(UIView *) parentView;
+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView;

+ (CGFloat) currentEditorWidth;

@end
