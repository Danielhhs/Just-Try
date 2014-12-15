//
//  AnimationDescription.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationParameters.h"
#import "AnimationConstants.h"
@interface AnimationDescription : NSObject
@property (nonatomic) AnimationEvent animationEvent;
@property (nonatomic, strong) NSString *animationName;
@property (nonatomic) AnimationEffect animationEffect;
@property (nonatomic, strong) AnimationParameters *parameters;
- (instancetype) initWithAnimationEffect:(AnimationEffect)animationEffect forEvent:(AnimationEvent) animationEvent parameters:(AnimationParameters *)parameters;
+ (AnimationDescription *) animationDescriptionWithAnimationEffect:(AnimationEffect) animationEffect
                                                  animationEvent:(AnimationEvent) animationEvent
                                                        duration:(NSTimeInterval)duration
                                              permittedDirection:(AnimationPermittedDirection) direction
                                          timeAfterLastAnimation:(NSTimeInterval) timeAfterLastAnimation;
@end
