//
//  GenericContainerViewHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericContainerView.h"

#define ANGELS_PER_PI 180
#define GOLDEN_RATIO 0.618
#define COUNTER_GOLDEN_RATIO 0.372

@interface GenericContainerViewHelper : NSObject
+ (NSString *) fontKey;
+ (NSString *) alignmentKey;
+ (NSString *) rotationKey;
+ (NSString *) reflectionKey;
+ (NSString *) shadowKey;
+ (NSString *) reflectionAlphaKey;
+ (NSString *) reflectionSizeKey;
+ (NSString *) shadowAlphaKey;
+ (NSString *) shadowSizeKey;
+ (NSString *) imageNameKey;
+ (NSString *) attibutedStringKey;
+ (NSString *) frameKey;
+ (NSString *) restoreKey;
+ (NSDictionary *) defaultTextAttributes;
+ (NSDictionary *) defaultImageAttributes;
+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes;
+ (void) applyAttribute:(NSDictionary *) attributes toContainer:(GenericContainerView *) containerView;
+ (void) resetActualTransformWithView:(GenericContainerView*) container;
@end
