//
//  AnimationPlayer.m
//  iDo
//
//  Created by Huang Hongsen on 1/28/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "AnimationPlayer.h"
#import "AnimationRenderer.h"
#import "AnvilAnimationRenderer.h"
@interface AnimationPlayer ()

@end

static AnimationPlayer *sharedInstance;

@implementation AnimationPlayer
#pragma mark - Singleton
+ (AnimationPlayer *) player
{
    if (!sharedInstance) {
        sharedInstance = [[AnimationPlayer alloc] initInternal];
    }
    return sharedInstance;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype) init
{
    return nil;
}

#pragma mark - Play Animation
- (void) playAnimation:(AnimationDTO *)animation inCanvas:(PlayingCanvasView *)canvas
{
    AnimationRenderer *renderer = [self rendererForAnimationType:animation.effect event:animation.event];
    [renderer animateObject:animation inCanvas:canvas completion:^{
        
    }];
}

- (AnimationRenderer *) rendererForAnimationType:(AnimationEffect) animationType event:(AnimationEvent)event
{
    switch (animationType) {
        case AnimationEffectAnvil:
            return [[AnvilAnimationRenderer alloc] init];
        default:
            return nil;
    }
}

@end
