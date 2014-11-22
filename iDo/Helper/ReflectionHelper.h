//
//  ReflectionHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReflectionShadowType.h"
typedef NS_ENUM(NSInteger, ContentViewReflectionType) {
    ContentViewReflectionTypeUnderOriginal = 0,
    ContentViewReflectionTypeHorizontalMirror = 1,
    ContentViewReflectionTypeVerticalMirror = 2
};

@interface ReflectionHelper : NSObject
+ (NSArray *) reflectionTypes;
@end
