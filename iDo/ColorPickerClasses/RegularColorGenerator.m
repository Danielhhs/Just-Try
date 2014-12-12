//
//  RegularColorGenerator.m
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RegularColorGenerator.h"
#import <UIKit/UIKit.h>
#import "DrawingConstants.h"
static NSArray *regularColorArray;


@implementation RegularColorGenerator

+ (NSArray *) regularColors
{
    if (regularColorArray) {
        return regularColorArray;
    }
    NSMutableArray *colors = [NSMutableArray array];
    
    [colors addObject:[UIColor darkGrayColor]];
    [colors addObject:[UIColor lightGrayColor]];
    [colors addObject:[UIColor grayColor]];
    [colors addObject:[UIColor cyanColor]];
    [colors addObject:[UIColor magentaColor]];
    [colors addObject:[UIColor orangeColor]];
    [colors addObject:[UIColor purpleColor]];
    [colors addObject:[UIColor brownColor]];
    [colors addObject:[UIColor lightTextColor]];
    [colors addObject:[UIColor darkTextColor]];
    [colors addObject:[UIColor groupTableViewBackgroundColor]];
    
    NSArray *goldenRatios = @[@(0), @([DrawingConstants goldenRatio]), @(1)];
    for (NSNumber *redNumber in goldenRatios) {
        CGFloat red = [redNumber doubleValue];
        for (NSNumber *greenNumber in goldenRatios) {
            CGFloat green = [greenNumber doubleValue];
            for (NSNumber *blueNumber in goldenRatios) {
                CGFloat blue = [blueNumber doubleValue];
                UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
                [colors addObject:color];
            }
        }
    }
    
    regularColorArray = [colors copy];
    return regularColorArray;
}

@end
