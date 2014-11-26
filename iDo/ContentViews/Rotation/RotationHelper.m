//
//  RotationHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationHelper.h"
#import "RotationIndicatorView.h"

static RotationIndicatorView *rotationIndicator;

@implementation RotationHelper

+ (void) applyRotationIndicatorToView:(UIView *)view
{
    if (rotationIndicator == nil) {
        rotationIndicator = [[RotationIndicatorView alloc] initWithFrame:CGRectZero];
    }
    [view addSubview:rotationIndicator];
    [rotationIndicator applyToView:view];
}

+ (void) updateRotationIndicator
{
    [rotationIndicator update];
}

+ (void) hideRotationIndicator
{
    [rotationIndicator removeFromSuperview];
}
@end
