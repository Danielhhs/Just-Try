//
//  PlayingModeTransitionDelegate.m
//  iDo
//
//  Created by Huang Hongsen on 1/25/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "PlayingModeTransitionDelegate.h"
#import "SlidesPlayViewController.h"
#import "SlidesContainerViewController.h"

@interface PlayingModeTransitionDelegate ()<UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL presenting;
@end

static PlayingModeTransitionDelegate *sharedInstance;

@implementation PlayingModeTransitionDelegate

#pragma mark - Singleton
+ (PlayingModeTransitionDelegate *) generalDelegate
{
    if (sharedInstance == nil) {
        sharedInstance = [[PlayingModeTransitionDelegate alloc] initInternal];
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
    if (self) {
        
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (CGFloat) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.382;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presenting) {
        SlidesPlayViewController *toViewController = (SlidesPlayViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        SlidesContainerViewController *fromViewController = (SlidesContainerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[fromViewController currentSlideFrame]];
        imageView.image = [fromViewController currentSlideSnapshot];
        [[transitionContext containerView] addSubview:imageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = [toViewController canvasFrame];
        } completion:^(BOOL finished) {
            [[transitionContext containerView] addSubview:toViewController.view];
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else {
        SlidesPlayViewController *fromViewController = (SlidesPlayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        SlidesContainerViewController *toViewController = (SlidesContainerViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[fromViewController canvasFrame]];
        imageView.image = [fromViewController canvasSnapshot];
        [[transitionContext containerView] addSubview:imageView];
        [fromViewController.view removeFromSuperview];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = [toViewController currentSlideFrame];
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}
@end
