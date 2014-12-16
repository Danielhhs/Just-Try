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
- (void) applyAnimationOrderIndicatorToView:(GenericContainerView *)view
{
    if ([[AnimationModeManager sharedManager] isInAnimationMode]) {
        [view addSubview:self.animationControlPoint];
        self.animationControlPoint.transform = CGAffineTransformInvert(view.transform);
        NSArray *animations = [[view attributes] valueForKey:[KeyConstants animationsKey]];
        self.animationControlPoint.animateInOrder = -1;
        self.animationControlPoint.animateOutOrder = -1;
        for (NSDictionary *animation in animations) {
            if ([animation[[KeyConstants animationEventKey]] integerValue] == AnimationEventBuiltIn) {
                self.animationControlPoint.animateInOrder = [animation[[KeyConstants animationIndexKey]] integerValue];
            } else if ([animation[[KeyConstants animationEventKey]] integerValue] == AnimationEventBuiltOut) {
                self.animationControlPoint.animateOutOrder = [animation[[KeyConstants animationIndexKey]] integerValue];
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
