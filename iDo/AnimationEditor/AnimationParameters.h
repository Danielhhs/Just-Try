//
//  AnimationParameters.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnimationPermittedDirection) {
    AnimationPermittedDirectionLeft = 1 << 0,
    AnimationPermittedDirectionRight = 1 << 1,
    AnimationPermittedDirectionUp = 1 << 2,
    AnimationPermittedDirectionBottom = 1 << 3,
    AnimationPermittedDirectionHorizontal = AnimationPermittedDirectionLeft | AnimationPermittedDirectionRight,
    AnimationPermittedDirectionVertical = AnimationPermittedDirectionBottom | AnimationPermittedDirectionUp,
    AnimationPermittedDirectionAny = AnimationPermittedDirectionHorizontal | AnimationPermittedDirectionVertical
};

@interface AnimationParameters : NSObject
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimationPermittedDirection direction;
@property (nonatomic) NSTimeInterval timeAfterPreviousAnimation;

+ (AnimationParameters *) animationParametersWithDuration:(NSTimeInterval) duration
                                       permittedDirection:(AnimationPermittedDirection) permittedDirection
                               timeAfterPreviousAnimation:(NSTimeInterval) timeAfterLastAnimation;
@end
