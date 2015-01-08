//
//  AnimationOrderManager.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationOrderManager.h"
#import "AnimationControlPointView.h"
#import "KeyConstants.h"
#import "AnimationConstants.h"
#import "DrawingConstants.h"
#import "AnimationModeManager.h"
#import "AnimationDTO.h"

@interface AnimationOrderManager ()
@property (nonatomic, strong) AnimationControlPointView *animationControlPoint;
@end

static AnimationOrderManager *sharedInstance;

@implementation AnimationOrderManager
#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.animationControlPoint = [[AnimationControlPointView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

+ (AnimationOrderManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[AnimationOrderManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Show & Hide
- (void) applyAnimationOrderIndicatorToView:(UIView *)view
{
    if (![view isKindOfClass:[GenericContainerView class]]) {
        return ;
    }
    GenericContainerView *content = (GenericContainerView *) view;
    if ([[AnimationModeManager sharedManager] isInAnimationMode]) {
        [content addSubview:self.animationControlPoint];
        self.animationControlPoint.transform = CGAffineTransformInvert(view.transform);
        NSArray *animations = content.attributes.animations;
        self.animationControlPoint.animateInOrder = -1;
        self.animationControlPoint.animateOutOrder = -1;
        for (AnimationDTO *animation in animations) {
            if (animation.event == AnimationEventBuiltIn) {
                self.animationControlPoint.animateInOrder = animation.index;
            } else if (animation.event == AnimationEventBuiltOut) {
                self.animationControlPoint.animateOutOrder = animation.index;
            }
        }
        self.animationControlPoint.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMinY([self borderRectFromContainerViewBounds:view.bounds]));
    }
}

- (CGRect) borderRectFromContainerViewBounds:(CGRect) containerViewBounds
{
    CGRect result;
    result.origin.x = [DrawingConstants controlPointSizeHalf];
    result.origin.y = [DrawingConstants controlPointSizeHalf];
    result.size.width = containerViewBounds.size.width - 2 * [DrawingConstants controlPointSizeHalf];
    result.size.height = containerViewBounds.size.height - 2 * [DrawingConstants controlPointSizeHalf];
    return result;
}

- (void) updateAnimationOrderIndicatorToView:(UIView *)view
{
    if ([[AnimationModeManager sharedManager] isInAnimationMode]) {
        self.animationControlPoint.transform = CGAffineTransformInvert(view.transform);
    }
}

- (void) hideAnimationOrderIndicator
{
    [self.animationControlPoint removeFromSuperview];
}
@end
