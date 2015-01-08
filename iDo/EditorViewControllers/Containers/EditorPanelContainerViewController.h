//
//  EditorPanelContainerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorPanelViewController.h"

@class EditorPanelContainerViewController;
@protocol EditorPanelContainerViewControllerDelegate <NSObject>

- (void) editorContainerViewController:(EditorPanelContainerViewController *)container
                   didChangeAttributes:(NSDictionary *) attributes;

@end

@interface EditorPanelContainerViewController : UIViewController<EditorPanelViewControllerDelegate>

@property (nonatomic, weak) id<EditorPanelContainerViewControllerDelegate> delegate;

@property (nonatomic, weak) id<OperationTarget> target;
- (void) applyAttributes:(GenericContentDTO *) attributes;
- (void) hideTooltip;
- (CGRect) contentFrameFromYPosition:(CGFloat) yPosition;
@end
