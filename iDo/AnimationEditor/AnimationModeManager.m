//
//  AnimationModeManager.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationModeManager.h"

@interface AnimationModeManager ()
@property (nonatomic) BOOL animationMode;
@end
static AnimationModeManager *sharedInstance;
@implementation AnimationModeManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    return self;
}

+ (AnimationModeManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[AnimationModeManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Animation Mode Management
- (void) enterAnimationModeFromView:(UIView *)view
{
    self.animationMode = YES;
    [self.delegate applicationDidEnterAnimationModeFromView:view];
}

- (void) exitAnimationMode
{
    self.animationMode = NO;
    [self.delegate applicationDidExitAnimationMode];
}

- (BOOL) isInAnimationMode
{
    return self.animationMode;
}
@end
