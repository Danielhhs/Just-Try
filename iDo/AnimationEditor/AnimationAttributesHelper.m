//
//  AnimationAttributesHelper.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationAttributesHelper.h"
#import "KeyConstants.h"

@implementation AnimationAttributesHelper

+ (void) updateContentAttributes:(NSMutableDictionary *)attributes withAnimationDescription:(AnimationDescription *)animationDescription
{
    NSMutableArray *animations = attributes[[KeyConstants animationsKey]];
    
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
    editedAnimation[[KeyConstants animationEffectKey]] = @(animationDescription.animationEffect);
    editedAnimation[[KeyConstants animationDurationKey]] = @(animationDescription.parameters.duration);
    editedAnimation[[KeyConstants animationTriggerTimeKey]] = @(animationDescription.parameters.timeAfterPreviousAnimation);
    editedAnimation[[KeyConstants animationDirectionKey]] = @(animationDescription.parameters.direction);
    editedAnimation[[KeyConstants animationIndexKey]] = @(1);
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

@end
