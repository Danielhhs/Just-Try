//
//  AnimationModeManager.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol AnimationModeManagerDelegate <NSObject>

- (void) applicationDidEnterAnimationModeFromView:(UIView *)view;
- (void) applicationDidExitAnimationMode;

@end

@interface AnimationModeManager : NSObject
@property (nonatomic, weak) id<AnimationModeManagerDelegate> delegate;

+ (AnimationModeManager *) sharedManager;
- (void) enterAnimationModeFromView:(UIView *) view;
- (void) exitAnimationMode;
- (BOOL) isInAnimationMode;

@end
