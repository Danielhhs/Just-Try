//
//  AnimationEditorManager.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AnimationEditorContainerViewController.h"
#import "AnimationConstants.h"

@interface AnimationEditorManager : NSObject

+ (AnimationEditorManager *) sharedManager;

- (void) setAnimationEditorDelegate:(id<AnimationEditorContainerViewControllerDelegate>) delegate;

- (void) showAnimationEditorFromRect:(CGRect) rect
                              inView:(UIView *) view
                          forContent:(UIView *) content
                       animationType:(AnimationEvent) animationEvent;

@end
