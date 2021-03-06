//
//  AnimationAttributesHelper.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDescription.h"
#import "GenericContainerView.h"
@interface AnimationAttributesHelper : NSObject

+ (void) updateContent:(GenericContainerView *) content
withAnimationDescription:(AnimationDescription *)animationDescription
   generatingOperation:(BOOL)generatingOperation;
+ (NSString *) animationTitleForAnimationEffect:(AnimationEffect) effect;
+ (NSString *) animationInTitleForContent:(GenericContainerView *)content;
+ (NSString *) animationOutTitleForContent:(GenericContainerView *)content;
+ (AnimationEffect) animationEffectFromAnimationAttributes:(NSArray *) animations event:(AnimationEvent) event;
+ (AnimationParameters *) animationParametersFromAnimationAttributes:(NSArray *) animations event:(AnimationEvent) event;

+ (NSInteger) animationOrderForAttributes:(GenericContentDTO *)attributes event:(AnimationEvent) event;
@end
