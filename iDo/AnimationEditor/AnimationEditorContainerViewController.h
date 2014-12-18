//
//  AnimationEditorContainerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationDescription.h"
#import "AnimationConstants.h"
@protocol AnimationEditorContainerViewControllerDelegate
- (void) animationEditorDidSelectAnimation:(AnimationDescription *) animation;
- (void) animationEditorDidUpdateAnimationEffect:(AnimationDescription *) animation;
@end

@interface AnimationEditorContainerViewController : UIViewController
@property (nonatomic, strong) AnimationDescription *animation;
@property (nonatomic, weak) UIView *animationTarget;
@property (nonatomic, weak) id<AnimationEditorContainerViewControllerDelegate> delegate;
@property (nonatomic) NSInteger animationIndex;
@end
