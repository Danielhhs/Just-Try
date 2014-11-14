//
//  GenericContainerViewHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericContainerView.h"

@interface GenericContainerViewHelper : NSObject

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes;
+ (void) applyAttribute:(NSDictionary *) attributes toContainer:(GenericContainerView *) containerView;
+ (void) applyUndoAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView;
+ (void) resetActualTransformWithView:(GenericContainerView*) container;

+ (GenericContainerView *) contentViewFromAttributes:(NSMutableDictionary *)attributes delegate:(id<ContentContainerViewDelegate>) delegate;

+ (CGFloat) anglesFromTransform:(CGAffineTransform) transform;

+ (CGRect) frameFromAttributes:(NSDictionary *) attributes;
@end
