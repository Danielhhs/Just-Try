//
//  ToolbarManager.h
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SlideEditingToolbarViewController.h"
#import "AnimationToolbarViewController.h"

@interface ToolbarManager : NSObject

+ (ToolbarManager *) sharedManager;
- (void) showEditingToolBarToViewController:(UIViewController *)viewController;
- (void) hideEditingToolBarFromViewController:(UIViewController *) viewController;
- (void) showAnimationToolBarToViewController:(UIViewController *) viewController;
- (void) hideAnimationToolBarFromViewController:(UIViewController *) viewController;
- (CGFloat) toolbarHeight;
@end
