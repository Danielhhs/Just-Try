//
//  AnimationConstants.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnimationEvent) {
    AnimationEventBuiltIn = 0,
    AnimationEventBuiltOut = 1,
    AnimationEventTransition = 2,
    AnimationEventUnknown = 3
};

typedef NS_ENUM(NSInteger, AnimationEffect) {
    AnimationEffectNone = 0,
    AnimationEffectBreak = 1,
    AnimationEffectAnvil = 2,
    AnimationEffectFirework = 3,
    AnimationEffectFlame = 4,
    AnimationEffectTyper = 5,
    AnimationEffectResolve = 6,
    AnimationEffectJump = 7,
    AnimationEffectRotate = 8
};

typedef NS_ENUM(NSInteger, AnimationPermittedDirection) {
    AnimationPermittedDirectionLeft = 1 << 0,
    AnimationPermittedDirectionRight = 1 << 1,
    AnimationPermittedDirectionUp = 1 << 2,
    AnimationPermittedDirectionBottom = 1 << 3,
    AnimationPermittedDirectionHorizontal = AnimationPermittedDirectionLeft | AnimationPermittedDirectionRight,
    AnimationPermittedDirectionVertical = AnimationPermittedDirectionBottom | AnimationPermittedDirectionUp,
    AnimationPermittedDirectionAny = AnimationPermittedDirectionHorizontal | AnimationPermittedDirectionVertical,
    AnimationPermittedDirectionNone = 0,
};
@interface AnimationConstants : NSObject

@end
