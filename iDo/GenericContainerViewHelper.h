//
//  GenericContainerViewHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericContainerView.h"
#import "GenericContentDTO.h"

@interface GenericContainerViewHelper : NSObject

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(GenericContentDTO *) fullAttributes
             inGenericContainer:(GenericContainerView *) container;
+ (void) applyAttribute:(GenericContentDTO *) attributes toContainer:(GenericContainerView *) containerView;
//+ (void) applyUndoAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView;
+ (void) resetActualTransformWithView:(GenericContainerView*) container;

+ (GenericContainerView *) contentViewFromAttributes:(GenericContentDTO *)attributes delegate:(id<ContentContainerViewDelegate>) delegate;

+ (CGFloat) anglesFromTransform:(CGAffineTransform) transform;

+ (CGRect) frameFromAttributes:(GenericContentDTO *) attributes;
+ (void) applyRotation:(CGFloat) rotation
                toView:(UIView *) view;
@end
