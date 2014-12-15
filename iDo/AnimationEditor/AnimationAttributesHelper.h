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

+ (void) updateContentAttributes:(NSMutableDictionary *) attributes withAnimationDescription:(AnimationDescription *)animationDescription;
+ (NSString *) animationTitleForAnimationEffect:(AnimationEffect) effect;
+ (NSString *) animationInTitleForContent:(GenericContainerView *)content;
+ (NSString *) animationOutTitleForContent:(GenericContainerView *)content;
@end
