//
//  ReflectionHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ReflectionHelper.h"

@implementation ReflectionHelper

+ (NSArray *) reflectionTypes
{
    NSMutableArray *types = [NSMutableArray array];
    
    ReflectionShadowType *underOriginalType = [[ReflectionShadowType alloc] init];
    
    underOriginalType.type = ContentViewReflectionTypeUnderOriginal;
    underOriginalType.desc = @"Under Original";
    underOriginalType.thumbnailName = @"underOriginal.jpg";
    [types addObject:underOriginalType];
    
    ReflectionShadowType *horizontalMirrorType = [[ReflectionShadowType alloc] init];
    
    horizontalMirrorType.type = ContentViewReflectionTypeHorizontalMirror;
    horizontalMirrorType.desc = @"HorizontalMirror";
    horizontalMirrorType.thumbnailName = @"horizontalMirror.jpg";
    [types addObject:horizontalMirrorType];
    
    ReflectionShadowType *verticalMirrorType = [[ReflectionShadowType alloc] init];
    
    verticalMirrorType.type = ContentViewReflectionTypeVerticalMirror;
    verticalMirrorType.desc = @"Vertical Mirror";
    verticalMirrorType.thumbnailName = @"verticalMirror.jpg";
    [types addObject:underOriginalType];
    
    return [types copy];
}

@end
