//
//  AnimationTypesGenerator.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationTypesGenerator.h"
#import "AnimationConstants.h"
#import "TextContainerView.h"
#import "ImageContainerView.h"

static NSArray *animationTypesForTextView;
static NSArray *animationTypesForImageView;

@implementation AnimationTypesGenerator

+ (NSArray *) animationTypesForContentView:(GenericContainerView *)content type:(AnimationType)animationType
{
    if ([content isKindOfClass:[ImageContainerView class]]) {
        return [AnimationTypesGenerator animationTypesForImageContentOfType:animationType];
    } else if ([content isKindOfClass:[TextContainerView class]]) {
        return [AnimationTypesGenerator animationTypesForTextContentOfType:animationType];
    }
    return nil;
}

+ (NSArray *) animationTypesForImageContentOfType:(AnimationType) animationType
{
    if (!animationTypesForImageView) {
        animationTypesForImageView = @[@"Avil", @"Break", @"Flame", @"Firework", @"Moves", @"Resolve", @"Appear", @"Bang", @"Rotate"];
    }
    return animationTypesForImageView;
}

+ (NSArray *) animationTypesForTextContentOfType:(AnimationType) animationType
{
    if (!animationTypesForTextView) {
        animationTypesForTextView = @[@"Avil", @"Break", @"Flame", @"Firework", @"Moves", @"Resolve", @"Appear", @"Bang", @"Rotate", @"Typer"];
    }
    return animationTypesForTextView;
}

@end
