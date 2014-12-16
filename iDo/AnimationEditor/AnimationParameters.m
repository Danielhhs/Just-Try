//
//  AnimationParameters.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationParameters.h"

@implementation AnimationParameters

+ (AnimationParameters *) animationParametersWithDuration:(NSTimeInterval)duration permittedDirection:(AnimationPermittedDirection)permittedDirection selectedDirection:(AnimationPermittedDirection) selectedDirection timeAfterPreviousAnimation:(NSTimeInterval)timeAfterLastAnimation
{
    AnimationParameters *parameters = [[AnimationParameters alloc] init];
    parameters.duration = duration;
    parameters.permittedDirection = permittedDirection;
    parameters.timeAfterPreviousAnimation = timeAfterLastAnimation;
    parameters.selectedDirection = selectedDirection;
    return parameters;
}

- (id) copyWithZone:(NSZone *)zone
{
    AnimationParameters *parameters = [AnimationParameters animationParametersWithDuration:self.duration permittedDirection:self.permittedDirection selectedDirection:self.selectedDirection timeAfterPreviousAnimation:self.timeAfterPreviousAnimation];
    return parameters;
}

@end
