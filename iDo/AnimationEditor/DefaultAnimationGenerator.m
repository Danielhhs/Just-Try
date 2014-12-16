//
//  DefaultAnimationGenerator.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "DefaultAnimationGenerator.h"

@interface DefaultAnimationGenerator ()
@property (nonatomic, strong) AnimationDescription *noAnimation;
@property (nonatomic, strong) AnimationDescription *breakAnimation;
@property (nonatomic, strong) AnimationDescription *anvilAnimation;
@property (nonatomic, strong) AnimationDescription *fireworkAnimation;
@property (nonatomic, strong) AnimationDescription *flameAnimation;
@property (nonatomic, strong) AnimationDescription *rotateAnimation;
@property (nonatomic, strong) AnimationDescription *resolveAnimation;
@property (nonatomic, strong) AnimationDescription *typerAnimation;
@property (nonatomic, strong) AnimationDescription *jumpAnimation;
@end

static DefaultAnimationGenerator *sharedInstance;
@implementation DefaultAnimationGenerator
#pragma mark - Singleton
+ (DefaultAnimationGenerator *) generator
{
    if (!sharedInstance) {
        sharedInstance = [[DefaultAnimationGenerator alloc] initInternal];
    }
    return sharedInstance;
}

- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    return self;
}

#pragma mark - Animations
- (AnimationDescription *) breakAnimation
{
    if (!_breakAnimation) {
        _breakAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectBreak animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal selectedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _breakAnimation;
}

- (AnimationDescription *) anvilAnimation
{
    if (!_anvilAnimation) {
        _anvilAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectAnvil animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionUp selectedDirection:AnimationPermittedDirectionUp timeAfterLastAnimation:2.f];
    }
    return _anvilAnimation;
}

- (AnimationDescription *) fireworkAnimation
{
    if (!_fireworkAnimation) {
        _fireworkAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectFirework animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionBottom selectedDirection:AnimationPermittedDirectionBottom timeAfterLastAnimation:2.f];
    }
    return _fireworkAnimation;
}

- (AnimationDescription *) flameAnimation
{
    if (!_flameAnimation) {
        _flameAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectFlame animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionBottom selectedDirection:AnimationPermittedDirectionBottom timeAfterLastAnimation:2.f];
    }
    return _flameAnimation;
}

- (AnimationDescription *) rotateAnimation
{
    if (!_rotateAnimation) {
        _rotateAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectRotate animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal selectedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _rotateAnimation;
}

- (AnimationDescription *) resolveAnimation
{
    if (!_resolveAnimation) {
        _resolveAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectResolve animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionAny selectedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _resolveAnimation;
}

- (AnimationDescription *) jumpAnimation
{
    if (!_jumpAnimation) {
        _jumpAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectJump animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal selectedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _jumpAnimation;
}

- (AnimationDescription *) typerAnimation
{
    if (!_typerAnimation) {
        _typerAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectTyper animationEvent:AnimationEventUnknown duration:2.f permittedDirection:AnimationPermittedDirectionLeft selectedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _typerAnimation;
}

- (AnimationDescription *) noAnimation
{
    if (!_noAnimation) {
        _noAnimation = [AnimationDescription animationDescriptionWithAnimationEffect:AnimationEffectNone animationEvent:AnimationEventUnknown duration:0 permittedDirection:AnimationPermittedDirectionNone selectedDirection:AnimationPermittedDirectionNone timeAfterLastAnimation:0];
    }
    return _noAnimation;
}

@end
