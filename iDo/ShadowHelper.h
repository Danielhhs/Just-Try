//
//  ShadowHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#define DEFAULT_SHADOW_DEPTH 0.5
@class GenericContainerView;

@interface ShadowHelper : NSObject

+ (void) applyShadowToGenericContainerView:(GenericContainerView *)container;

+ (void) updateShadowOpacity:(CGFloat) shadowOpacity toGenericContainerView:(GenericContainerView *) container;

+ (void) hideShadowForGenericContainerView:(GenericContainerView *) container;

+ (NSArray *) shadowTypes;

@end
