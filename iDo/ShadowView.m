//
//  ShadowView.m
//  iDo
//
//  Created by Huang Hongsen on 10/24/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (void) drawRect:(CGRect)rect
{
    CGFloat curlFactor = 15.f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    [path moveToPoint:CGPointMake(0, maxY)];
    [path addLineToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(maxX, 0)];
    [path addLineToPoint:CGPointMake(maxX, maxY)];
    [path addCurveToPoint:CGPointMake(0, maxY)
            controlPoint1:CGPointMake(rect.size.width - curlFactor, rect.size.height - curlFactor)
            controlPoint2:CGPointMake(curlFactor, rect.size.height - curlFactor)];
    
}

@end
