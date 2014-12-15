//
//  DefaultAnimationGenerator.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "DefaultAnimationGenerator.h"

@interface DefaultAnimationGenerator ()
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
        _breakAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Break" duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal timeAfterLastAnimation:2.f];
    }
    return _breakAnimation;
}

- (AnimationDescription *) anvilAnimation
{
    if (!_anvilAnimation) {
        _anvilAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Avil" duration:2.f permittedDirection:AnimationPermittedDirectionUp timeAfterLastAnimation:2.f];
    }
    return _anvilAnimation;
}

- (AnimationDescription *) fireworkAnimation
{
    if (!_fireworkAnimation) {
        _fireworkAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Firework" duration:2.f permittedDirection:AnimationPermittedDirectionBottom timeAfterLastAnimation:2.f];
    }
    return _fireworkAnimation;
}

- (AnimationDescription *) flameAnimation
{
    if (!_flameAnimation) {
        _flameAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Flame" duration:2.f permittedDirection:AnimationPermittedDirectionBottom timeAfterLastAnimation:2.f];
    }
    return _flameAnimation;
}

- (AnimationDescription *) rotateAnimation
{
    if (!_rotateAnimation) {
        _rotateAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Rotate" duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal timeAfterLastAnimation:2.f];
    }
    return _rotateAnimation;
}

- (AnimationDescription *) resolveAnimation
{
    if (!_resolveAnimation) {
        _resolveAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Resolve" duration:2.f permittedDirection:AnimationPermittedDirectionAny timeAfterLastAnimation:2.f];
    }
    return _resolveAnimation;
}

- (AnimationDescription *) jumpAnimation
{
    if (!_jumpAnimation) {
        _jumpAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Jump" duration:2.f permittedDirection:AnimationPermittedDirectionHorizontal timeAfterLastAnimation:2.f];
    }
    return _jumpAnimation;
}

- (AnimationDescription *) typerAnimation
{
    if (!_typerAnimation) {
        _typerAnimation = [AnimationDescription animationDescriptionWithAnimationName:@"Typer" duration:2.f permittedDirection:AnimationPermittedDirectionLeft timeAfterLastAnimation:2.f];
    }
    return _typerAnimation;
}

@end
