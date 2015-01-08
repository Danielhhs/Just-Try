//
//  AnimationAttributesHelper.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationAttributesHelper.h"
#import "KeyConstants.h"
#import "SimpleOperation.h"
#import "UndoManager.h"
#import "SlideAttributesManager.h"
#import "AnimationDTO.h"

@implementation AnimationAttributesHelper

+ (void) updateContent:(GenericContainerView *) content
withAnimationDescription:(AnimationDescription *)animationDescription
   generatingOperation:(BOOL)generatingOperation
{
    NSArray *originalAnimations = [content.attributes.animations mutableCopy];
    [[SlideAttributesManager sharedManager] updateSlideWithAnimationDescription:animationDescription content:content];
    if (generatingOperation) {
        SimpleOperation *operation = [[SimpleOperation alloc] initWithTargets:@[content] key:[KeyConstants animationsKey] fromValue:originalAnimations];
        operation.toValue = [content.attributes.animations copy];
        [[UndoManager sharedManager] pushOperation:operation];
    }
    
}

+ (NSString *) animationTitleForAnimationEffect:(AnimationEffect) effect
{
    switch (effect) {
        case AnimationEffectTyper:
        return @"Typer";
        case AnimationEffectJump:
        return @"Jump";
        case AnimationEffectResolve:
        return @"Resolve";
        case AnimationEffectFlame:
        return @"Flame";
        case AnimationEffectFirework:
        return @"Firework";
        case AnimationEffectAnvil:
        return @"Anvil";
        case AnimationEffectBreak:
        return @"Break";
        case AnimationEffectRotate:
        return @"Rotate";
        default:
            return @"None";
        break;
    }
}

+ (NSString *) animationInTitleForContent:(GenericContainerView *)content
{
    NSArray *animations = content.attributes.animations;
    NSString *title = @"None";
    for (AnimationDTO *animation in animations) {
        AnimationEvent event = animation.event;
        if (event == AnimationEventBuiltIn) {
            title = [AnimationAttributesHelper animationTitleForAnimationEffect:animation.effect];
        }
    }
    return title;
}

+ (NSString *) animationOutTitleForContent:(GenericContainerView *)content
{
    NSArray *animations = content.attributes.animations;
    NSString *title = @"None";
    for (AnimationDTO *attributes in animations) {
        AnimationEvent event = attributes.event;
        if (event == AnimationEventBuiltOut) {
            title = [AnimationAttributesHelper animationTitleForAnimationEffect:attributes.effect];
        }
    }
    return title;
}

+ (AnimationEffect) animationEffectFromAnimationAttributes:(NSArray *)animations event:(AnimationEvent)event
{
    AnimationEffect effect = AnimationEffectNone;
    for (AnimationDTO *animation in animations) {
        AnimationEvent animationEvent = animation.event;
        if (animationEvent == event) {
            effect = animation.effect;
        }
    }
    return effect;
}

+ (AnimationParameters *) animationParametersFromAnimationAttributes:(NSArray *)animations event:(AnimationEvent)event
{
    AnimationParameters *parameters = [[AnimationParameters alloc] init];
    for (AnimationDTO *animation in animations) {
        AnimationEvent animationEvent = animation.event;
        if (animationEvent == event) {
            parameters.duration = animation.duration;
            parameters.selectedDirection = animation.direction;
            parameters.timeAfterPreviousAnimation = animation.triggeredTime;
        }
    }
    return parameters;
}

+ (NSInteger) animationOrderForAttributes:(GenericContentDTO *)attributes event:(AnimationEvent) event
{
    NSInteger order = -1;
    for (AnimationDTO *animation in attributes.animations) {
        if (animation.event == event) {
            order = animation.index;
            break;
        }
    }
    return order;
}
@end
