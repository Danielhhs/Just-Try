//
//  RotationHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationHelper.h"
#import "RotationIndicatorView.h"

#define ANGELS_PER_PI 180

@implementation RotationHelper

+ (void) applyRotationIndicator:(RotationIndicatorView *)rotationIndicator
                         toView:(UIView *)view
{
    [rotationIndicator applyToView:view];
}

+ (void) hideRotationIndicator:(RotationIndicatorView *) rotationIndicator
{
    [rotationIndicator hide];
}
@end
