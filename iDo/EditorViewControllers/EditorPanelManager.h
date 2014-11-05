//
//  EditorPanelHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentItem.h"
#import "ImageItem.h"
#import "TextItem.h"
#import "GenericContainerView.h"
#import "SliderEditingViewController.h"

@interface EditorPanelManager : NSObject

+ (EditorPanelManager *) sharedManager;

- (void) showEditorPanelInViewController:(SliderEditingViewController *) viewController
                          forContentView:(GenericContainerView *)contentView;

- (void) showImageEditorInViewController:(SliderEditingViewController *) viewController
                              attributes:(NSDictionary *) imageItem
                                  target:(id<OperationTarget>)target;
- (void) showTextEditorInViewController:(SliderEditingViewController *) viewController
                             attributes:(NSDictionary *) imageItem
                                 target:(id<OperationTarget>)target;

- (void) dismissAllEditorPanelsFromViewController:(SliderEditingViewController *) viewController;

- (void) makeCurrentEditorApplyChanges:(NSDictionary *) attributes;

- (void) handleContentViewDidFinishChanging;

- (void) contentViewDidSelectRange:(NSRange) range;

+ (CGRect) editorPanelFrameInView:(UIView *) parentView;
+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView;

+ (CGFloat) currentEditorWidth;

@end
