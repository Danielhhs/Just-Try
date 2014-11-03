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
+ (NSDictionary *) defaultTextAttributes;
+ (NSDictionary *) defaultImageAttributes;

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes;
+ (void) applyAttribute:(NSDictionary *) attributes toContainer:(GenericContainerView *) containerView;
+ (void) applyUndoAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView;
+ (void) resetActualTransformWithView:(GenericContainerView*) container;

+ (CGFloat) anglesFromTransform:(CGAffineTransform) transform;
@end
