//
//  DrawingConstants.m
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "DrawingConstants.h"

@implementation DrawingConstants

+ (CGFloat) topBarHeight
{
    return 44.f;
}

+ (CGFloat) slidesEditorContentHeight
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    return height - [DrawingConstants topBarHeight];
}

+ (CGFloat) slidesThumbnailWidth
{
    return 200.f;
}

+ (CGFloat) goldenRatio
{
    return 0.618;
}

+ (CGFloat) counterGoldenRatio
{
    return 0.372;
}

+ (CGFloat) angelsPerPi
{
    return 180;
}

+ (CGFloat) gapBetweenViews
{
    return 12.f;
}

@end
