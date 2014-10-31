//
//  RotationTooltipView.m
//  iDo
//
//  Created by Huang Hongsen on 10/31/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationTooltipView.h"

#define ROTATION_TOOLTIP_CORNER_RADIUS 10.f

@implementation RotationTooltipView

- (void) drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:ROTATION_TOOLTIP_CORNER_RADIUS];
    [[UIColor darkTextColor] setFill];
    [bezierPath fill];
}

- (CGFloat) arrowHeight
{
    return 0;
}

@end
