//
//  ReflectionHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShadowType.h"
#import <UIKit/UIKit.h>
@class GenericContainerView;
typedef NS_ENUM(NSInteger, ContentViewReflectionType) {
    ContentViewReflectionTypeNone = 0,
    ContentViewReflectionTypeVerticalMirror = 1
};

@interface ReflectionHelper : NSObject
+ (void) applyReflectionViewToGenericContainerView:(GenericContainerView *) container;
+ (void) hideReflectionViewFromGenericContainerView:(GenericContainerView *) container;
+ (UIImage *) reflectionImageForGenericContainerView:(GenericContainerView *) container;
@end
