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
    AnimationEventTransition = 2
};

typedef NS_ENUM(NSInteger, AnimationEffect) {
    AnimationEffectBreak = 1,
    AnimationEffectAnvil = 2,
    AnimationEffectFirework = 3,
    AnimationEffectFlame = 4,
    AnimationEffectTyper = 5,
    AnimationEffectResolve = 6,
    AnimationEffectJump = 7,
    AnimationEffectRotate = 8
};
@interface AnimationConstants : NSObject

@end
