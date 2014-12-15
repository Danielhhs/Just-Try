//
//  AnimationDescription.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationDescription.h"

@implementation AnimationDescription

- (instancetype) initWithAnimationName:(NSString *)animationName parameters:(AnimationParameters *)parameters
{
    self = [super init];
    if (self) {
        _animationName = animationName;
        _parameters = parameters;
    }
    return self;
}

+ (AnimationDescription *) animationDescriptionWithAnimationName:(NSString *)animationName duration:(NSTimeInterval)duration permittedDirection:(AnimationPermittedDirection)direction timeAfterLastAnimation:(NSTimeInterval)timeAfterLastAnimation
{
    AnimationParameters *parameters = [AnimationParameters animationParametersWithDuration:duration permittedDirection:direction timeAfterPreviousAnimation:timeAfterLastAnimation];
    AnimationDescription *animation = [[AnimationDescription alloc] initWithAnimationName:animationName parameters:parameters];
    return animation;
}
@end
