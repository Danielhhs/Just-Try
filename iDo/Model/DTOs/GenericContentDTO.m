//
//  GenericContentDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "GenericContentDTO.h"
#import "DrawingConstants.h"
#import "AnimationDTO.h"
@implementation GenericContentDTO

+ (void) applyDefaultGenericContentToContentDTO:(GenericContentDTO *)content
{
    content.opacity = 1;
    content.reflection = NO;
    content.shadow = NO;
    content.reflectionAlpha = [DrawingConstants goldenRatio];
    content.reflectionSize = [DrawingConstants counterGoldenRatio];
    content.shadowType = ContentViewShadowTypeNone;
    content.shadowAlpha = [DrawingConstants goldenRatio];
    content.shadowSize = [DrawingConstants counterGoldenRatio];
    content.transform = CGAffineTransformIdentity;
    content.uuid = [NSUUID UUID];
    content.animations = [NSMutableArray array];
}

- (BOOL) shouldShowOnPlayingCanvasAppear
{
    BOOL shouldShow = NO;
    if ([self.animations count] == 1) {
        AnimationDTO *animation = [self.animations lastObject];
        if (animation.event == AnimationEventBuiltOut) {
            shouldShow = YES;
        }
    } else if ([self.animations count] == 2) {
        AnimationDTO *builtInAnimation;
        AnimationDTO *builtOutAnimation;
        for (AnimationDTO *animation in self.animations) {
            if (animation.event == AnimationEventBuiltIn) {
                builtInAnimation = animation;
            } else if (animation.event == AnimationEventBuiltOut) {
                builtOutAnimation = animation;
            }
        }
        if (builtOutAnimation.index < builtInAnimation.index) {
            shouldShow = YES;
        }
    } else if ([self.animations count] == 0) {
        shouldShow = YES;
    }
    return shouldShow;
}

@end
