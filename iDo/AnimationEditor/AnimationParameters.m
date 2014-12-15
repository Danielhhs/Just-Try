//
//  AnimationParameters.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationParameters.h"

@implementation AnimationParameters

+ (AnimationParameters *) animationParametersWithDuration:(NSTimeInterval)duration permittedDirection:(AnimationPermittedDirection)permittedDirection timeAfterPreviousAnimation:(NSTimeInterval)timeAfterLastAnimation
{
    AnimationParameters *parameters = [[AnimationParameters alloc] init];
    parameters.duration = duration;
    parameters.direction = permittedDirection;
    parameters.timeAfterPreviousAnimation = timeAfterLastAnimation;
    return parameters;
}

@end
