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

@interface EditorPanelManager : NSObject

+ (EditorPanelManager *) sharedManager;

- (void) showEditorPanelInViewController:(UIViewController *) viewController
                          forContentView:(GenericContainerView *)contentView;

- (void) showImageEditorInViewController:(UIViewController *) viewController
                        imageInformation:(ContentItem *) imageItem;
- (void) showTextEditorInViewController:(UIViewController *) viewController
                        imageInformation:(ContentItem *) textItem;

- (void) dismissAllEditorPanelsFromViewController:(UIViewController *) viewController;

+ (CGRect) editorPanelFrameInView:(UIView *) parentView;
+ (CGRect) editorPanelFrameOutOfView:(UIView *) parentView;
@end
