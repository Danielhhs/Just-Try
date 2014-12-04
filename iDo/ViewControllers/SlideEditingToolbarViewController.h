//
//  SlideEditingToolbarViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/21/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerView.h"
#import "UndoManager.h"

@class SlideEditingToolbarViewController;
@protocol SlideEditingToolbarDelegate <NSObject>

- (void) toolBarViewControllerWillPerformUndoAction:(SlideEditingToolbarViewController *) controller ;
- (void) addGenericContentView:(GenericContainerView *) content;
- (void) deleteCurrentSelectedContent;
- (void) saveProposal;
- (void) backToProposals;
- (void) editCurrentContent;
@end

@interface SlideEditingToolbarViewController : UIViewController<UndoManagerDelegate>
@property (nonatomic, weak) id<SlideEditingToolbarDelegate> delegate;
@end
