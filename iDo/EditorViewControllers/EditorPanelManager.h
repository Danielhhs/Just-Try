//
//  EditorPanelHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerView.h"
#import "SlidesEditingViewController.h"

@interface EditorPanelManager : NSObject

+ (EditorPanelManager *) sharedManager;

- (void) showEditorPanelInViewController:(SlidesEditingViewController *) viewController
                          forContentView:(GenericContainerView *)contentView;

- (void) showImageEditorInViewController:(SlidesEditingViewController *) viewController
                              attributes:(NSDictionary *) imageItem
                                  target:(id<OperationTarget>)target;
- (void) showTextEditorInViewController:(SlidesEditingViewController *) viewController
                             attributes:(NSDictionary *) imageItem
                                 target:(id<OperationTarget>)target;

- (void) dismissAllEditorPanelsFromViewController:(SlidesEditingViewController *) viewController;

- (void) makeCurrentEditorApplyChanges:(NSDictionary *) attributes;

- (void) handleContentViewDidFinishChanging;

- (void) contentViewDidSelectRange:(NSRange) range;

- (void) selectTextBasicEditorPanel;

+ (CGRect) editorPanelFrameInView:(UIView *) parentView;
+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView;

+ (CGFloat) currentEditorWidth;

@end
