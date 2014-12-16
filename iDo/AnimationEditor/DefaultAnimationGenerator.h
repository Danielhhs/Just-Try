//
//  DefaultAnimationGenerator.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDescription.h"
@interface DefaultAnimationGenerator : NSObject

+ (DefaultAnimationGenerator *) generator;

- (AnimationDescription *) breakAnimation;
- (AnimationDescription *) anvilAnimation;
- (AnimationDescription *) fireworkAnimation;
- (AnimationDescription *) flameAnimation;
- (AnimationDescription *) rotateAnimation;
- (AnimationDescription *) resolveAnimation;
- (AnimationDescription *) typerAnimation;
- (AnimationDescription *) jumpAnimation;
- (AnimationDescription *) noAnimation;

@end
