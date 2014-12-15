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
#import "DefaultAnimationGenerator.h"
@interface AnimationTypesGenerator()
@property (nonatomic, strong) NSArray *animationInTypesForTextView;
@property (nonatomic, strong) NSArray *animationOutTypesForTextView;
@property (nonatomic, strong) NSArray *animationInTypesForImageView;
@property (nonatomic, strong) NSArray *animationOutTypesForImageView;
@property (nonatomic, strong) NSArray *animationTypesForTransition;
@end

static AnimationTypesGenerator *sharedInstance;
@implementation AnimationTypesGenerator

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    return self;
}

+ (AnimationTypesGenerator *) generator
{
    if (!sharedInstance) {
        sharedInstance = [[AnimationTypesGenerator alloc] initInternal];
    }
    return sharedInstance;
}

- (NSArray *) animationInTypesForImageView
{
    if (!_animationInTypesForImageView) {
        _animationInTypesForImageView = [self generateAnimationInTypesForImage];
    }
    return _animationInTypesForImageView;
}

-(NSArray *) animationInTypesForTextView
{
    if (!_animationInTypesForTextView) {
        _animationInTypesForTextView = [self generateAnimationInTypesForText];
    }
    return _animationInTypesForTextView;
}

#pragma mark - Animations
- (NSArray *) animationTypesForContentView:(GenericContainerView *)content type:(AnimationType)animationType
{
    if ([content isKindOfClass:[ImageContainerView class]]) {
        return [self animationTypesForImageContentOfType:animationType];
    } else if ([content isKindOfClass:[TextContainerView class]]) {
        return [self animationTypesForTextContentOfType:animationType];
    }
    return nil;
}

- (NSArray *) animationTypesForImageContentOfType:(AnimationType) animationType
{
    return animationType == AnimationTypeBuiltIn ? self.animationInTypesForImageView : self.animationOutTypesForImageView;
}

- (NSArray *) animationTypesForTextContentOfType:(AnimationType) animationType
{
    return animationType == AnimationTypeBuiltIn ? self.animationInTypesForTextView : self.animationOutTypesForTextView;
}

- (NSArray *) animationTypesForTransition
{
    return self.animationTypesForTransition;
}

- (NSArray *) generateAnimationInTypesForImage
{
    NSMutableArray *animationTypes = [NSMutableArray array];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] anvilAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] fireworkAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] flameAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] rotateAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] breakAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] resolveAnimation]];
    return [animationTypes copy];
}

- (NSArray *) generateAnimationInTypesForText
{
    NSMutableArray *animationTypes = [self.animationInTypesForImageView mutableCopy];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] typerAnimation]];
    [animationTypes addObject:[[DefaultAnimationGenerator generator] jumpAnimation]];
    return [animationTypes copy];
}

@end
