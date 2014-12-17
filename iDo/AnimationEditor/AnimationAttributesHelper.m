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

@implementation AnimationAttributesHelper

+ (void) updateContent:(GenericContainerView *) content withAnimationDescription:(AnimationDescription *)animationDescription generatingOperation:(BOOL)generatingOperation
{
    NSArray *originalAnimations = [[[content attributes] objectForKey:[KeyConstants animationsKey]] copy];
    [AnimationAttributesHelper updateContentAttributes:[content attributes] withAnimationDescription:animationDescription];
    if (generatingOperation) {
        SimpleOperation *operation = [[SimpleOperation alloc] initWithTargets:@[content] key:[KeyConstants animationsKey] fromValue:originalAnimations];
        operation.toValue = [[[content attributes] objectForKey:[KeyConstants animationsKey]] copy];
        [[UndoManager sharedManager] pushOperation:operation];
    }
    
}

+ (void) updateContentAttributes:(NSMutableDictionary *)attributes withAnimationDescription:(AnimationDescription *)animationDescription
{
    NSMutableArray *animations = [attributes[[KeyConstants animationsKey]] mutableCopy];
    
    NSMutableDictionary *editedAnimation;
    for (NSMutableDictionary *animation in animations) {
        if ([animation[[KeyConstants animationEventKey]] integerValue] == animationDescription.animationEvent) {
            editedAnimation = animation;
            break;
        }
    }
    if (!editedAnimation) {
        editedAnimation = [NSMutableDictionary dictionary];
        editedAnimation[[KeyConstants animationEventKey]] = @(animationDescription.animationEvent);
        [animations addObject:editedAnimation];
    }
    if (animationDescription.animationEffect == AnimationEffectNone) {
        [animations removeObject:editedAnimation];
    } else {
        editedAnimation[[KeyConstants animationEffectKey]] = @(animationDescription.animationEffect);
        editedAnimation[[KeyConstants animationDurationKey]] = @(animationDescription.parameters.duration);
        editedAnimation[[KeyConstants animationTriggerTimeKey]] = @(animationDescription.parameters.timeAfterPreviousAnimation);
        editedAnimation[[KeyConstants animationDirectionKey]] = @(animationDescription.parameters.selectedDirection);
        editedAnimation[[KeyConstants animationIndexKey]] = @(1);
    }
    attributes[[KeyConstants animationsKey]] = animations;
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
    NSArray *animations = [[content attributes] objectForKey:[KeyConstants animationsKey]];
    NSString *title = @"None";
    for (NSDictionary *attributes in animations) {
        AnimationEvent event = [attributes[[KeyConstants animationEventKey]] integerValue];
        if (event == AnimationEventBuiltIn) {
            title = [AnimationAttributesHelper animationTitleForAnimationEffect:[attributes[[KeyConstants animationEffectKey]] integerValue]];
        }
    }
    return title;
}

+ (NSString *) animationOutTitleForContent:(GenericContainerView *)content
{
    NSArray *animations = [[content attributes] objectForKey:[KeyConstants animationsKey]];
    NSString *title = @"None";
    for (NSDictionary *attributes in animations) {
        AnimationEvent event = [attributes[[KeyConstants animationEventKey]] integerValue];
        if (event == AnimationEventBuiltOut) {
            title = [AnimationAttributesHelper animationTitleForAnimationEffect:[attributes[[KeyConstants animationEffectKey]] integerValue]];
        }
    }
    return title;
}

+ (AnimationEffect) animationEffectFromAnimationAttributes:(NSArray *)animations event:(AnimationEvent)event
{
    AnimationEffect effect = AnimationEffectNone;
    for (NSDictionary *animation in animations) {
        AnimationEvent animationEvent = [[animation objectForKey:[KeyConstants animationEventKey]] integerValue];
        if (animationEvent == event) {
            effect = [animation[[KeyConstants animationEffectKey]] integerValue];
        }
    }
    return effect;
}

+ (AnimationParameters *) animationParametersFromAnimationAttributes:(NSArray *)animations event:(AnimationEvent)event
{
    AnimationParameters *parameters = [[AnimationParameters alloc] init];
    for (NSDictionary *animation in animations) {
        AnimationEvent animationEvent = [[animation objectForKey:[KeyConstants animationEventKey]] integerValue];
        if (animationEvent == event) {
            parameters.duration = [animation[[KeyConstants animationDurationKey]] doubleValue];
            parameters.selectedDirection = [animation[[KeyConstants animationDirectionKey]] integerValue];
            parameters.timeAfterPreviousAnimation = [animation[[KeyConstants animationTriggerTimeKey]] doubleValue];
        }
    }
    return parameters;
}

@end
