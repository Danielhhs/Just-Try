//
//  ShadowHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ShadowHelper.h"
#import "KeyConstants.h"

#define SHADOW_CURL_FACTOR 0.618
#define MAX_SHADOW_DEPTH_RATIO 0.1

@implementation ShadowHelper

+ (UIBezierPath *) shadowPathWithShadowAttributes:(NSDictionary *)attributes
{
    CGFloat shadowDepthRatio = [attributes[[KeyConstants shadowSizeKey]] doubleValue];
    CGRect bounds = [attributes[[KeyConstants boundsKey]] CGRectValue];
    CGFloat curlFactor = SHADOW_CURL_FACTOR;
    CGFloat shadowDepth = MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * bounds.size.height;
    CGRect contentFrame = bounds;
    CGFloat minX = CGRectGetMinX(contentFrame);
    CGFloat minY = CGRectGetMaxY(contentFrame);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(minX, minY + shadowDepth)];
    [path addLineToPoint:CGPointMake(minX, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY + shadowDepth)];
    [path addCurveToPoint:CGPointMake(minX, minY + shadowDepth)
            controlPoint1:CGPointMake(minX + contentFrame.size.width * (1 - curlFactor), minY + shadowDepth * (1 - curlFactor))
            controlPoint2:CGPointMake(minX + contentFrame.size.width * curlFactor, minY + shadowDepth * (1 - curlFactor))];
    return path;
}
@end
