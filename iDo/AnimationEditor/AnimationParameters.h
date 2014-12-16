//
//  AnimationParameters.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationConstants.h"

@interface AnimationParameters : NSObject
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimationPermittedDirection permittedDirection;
@property (nonatomic) NSTimeInterval timeAfterPreviousAnimation;
@property (nonatomic) AnimationPermittedDirection selectedDirection;

+ (AnimationParameters *) animationParametersWithDuration:(NSTimeInterval) duration
                                       permittedDirection:(AnimationPermittedDirection) permittedDirection
                               timeAfterPreviousAnimation:(NSTimeInterval) timeAfterLastAnimation;
@end
