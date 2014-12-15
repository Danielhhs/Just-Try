//
//  AnimationDescription.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationParameters.h"
@interface AnimationDescription : NSObject
@property (nonatomic, strong) NSString *animationName;
@property (nonatomic, strong) AnimationParameters *parameters;
- (instancetype) initWithAnimationName:(NSString *) animationName parameters:(AnimationParameters *) parameters;
+ (AnimationDescription *) animationDescriptionWithAnimationName:(NSString *) animationName
                                                        duration:(NSTimeInterval)duration
                                              permittedDirection:(AnimationPermittedDirection) direction
                                          timeAfterLastAnimation:(NSTimeInterval) timeAfterLastAnimation;
@end
