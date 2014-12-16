//
//  AnimationDescription.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationDescription.h"
#import "AnimationAttributesHelper.h"
@implementation AnimationDescription

- (instancetype) initWithAnimationEffect:(AnimationEffect)animationEffect forEvent:(AnimationEvent) animationEvent parameters:(AnimationParameters *)parameters
{
    self = [super init];
    if (self) {
        _animationEffect = animationEffect;
        _animationEvent = animationEvent;
        _parameters = parameters;
        _animationName = [AnimationAttributesHelper animationTitleForAnimationEffect:animationEffect];
    }
    return self;
}

+ (AnimationDescription *) animationDescriptionWithAnimationEffect:(AnimationEffect) animationEffect
                                                  animationEvent:(AnimationEvent) animationEvent
                                                        duration:(NSTimeInterval)duration
                                              permittedDirection:(AnimationPermittedDirection) permittedDirection
                                                 selectedDirection:(AnimationPermittedDirection) selectedDirection
                                          timeAfterLastAnimation:(NSTimeInterval) timeAfterLastAnimation {
    AnimationParameters *parameters = [AnimationParameters animationParametersWithDuration:duration permittedDirection:permittedDirection selectedDirection:selectedDirection timeAfterPreviousAnimation:timeAfterLastAnimation];
    AnimationDescription *animation = [[AnimationDescription alloc] initWithAnimationEffect:animationEffect forEvent:animationEvent parameters:parameters];
    return animation;
}

- (id) copyWithZone:(NSZone *)zone
{
    AnimationDescription *copyAnimation = [[AnimationDescription alloc] initWithAnimationEffect:self.animationEffect forEvent:self.animationEvent parameters:[self.parameters copyWithZone:nil]];
    return copyAnimation;
}
@end
