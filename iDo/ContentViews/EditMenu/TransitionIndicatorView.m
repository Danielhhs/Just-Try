//
//  TransitionIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 12/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TransitionIndicatorView.h"
#import "DrawingConstants.h"

@implementation TransitionIndicatorView

- (UIColor *) fillColor
{
    if (self.selected) {
        return [UIColor colorWithRed:0.1 green:0.378431 blue:1 alpha:0.7];
    } else {
        return [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    }
}

- (UIColor *) textColor
{
    if (self.selected) {
        return [UIColor colorWithWhite:1 alpha:0.8];
    } else {
        return [UIColor whiteColor];
    }
}

- (void) drawIndicatorShape
{
    CGFloat midY = CGRectGetMidY(self.bounds);
    if (self.hasAnimation) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.bounds.size.width * [DrawingConstants counterGoldenRatio], self.bounds.size.height * [DrawingConstants counterGoldenRatio])];
        [path addLineToPoint:CGPointMake(self.bounds.size.width * [DrawingConstants goldenRatio], midY)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width * [DrawingConstants counterGoldenRatio], self.bounds.size.height * [DrawingConstants goldenRatio])];
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineWidth:3];
        [[self textColor] setStroke];
        [path stroke];
    } else {
        [self drawPlus];
    }
}

@end
