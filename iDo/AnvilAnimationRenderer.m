//
//  AvilAnimationRenderer.m
//  iDo
//
//  Created by Huang Hongsen on 1/26/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "AnvilAnimationRenderer.h"
#import "GenericContainerView.h"
#import "UIView+Snapshot.h"
@interface AnvilAnimationRenderer() <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@end

@implementation AnvilAnimationRenderer

- (void) animateObject:(AnimationDTO *)animation inCanvas:(PlayingCanvasView *)canvas completion:(void (^)(void))completion
{
    self.completion = completion;
    GenericContainerView *container = animation.target;
    container.hidden = YES;
    [canvas addSubview:container];
    CGPoint center = container.center;
    container.backgroundColor = [UIColor redColor];
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:[container contentView].bounds];
    animationView.image = [container contentSnapshot];
    animationView.center = center;
    animationView.transform = container.transform;
    CGFloat bottomBoundsY = CGRectGetMaxY(animationView.frame);
    animationView.center = CGPointMake(center.x, center.y - bottomBoundsY);
    [canvas addSubview:animationView];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:canvas];
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[animationView]];
    self.gravity.magnitude = [self magnitudeForView:container ofDuration:animation.duration];
    [self.animator addBehavior:self.gravity];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[animationView]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(container.frame.origin.x - 10, bottomBoundsY, container.frame.size.width + 20, 1)];
    [collision addBoundaryWithIdentifier:@"Anvil" forPath:path];
    collision.collisionDelegate = self;
    [self.animator addBehavior:collision];
    self.animator.delegate = self;
}

#pragma mark - UICollisionBehaviorDelegate
- (CGFloat) magnitudeForView:(UIView *)view ofDuration:(NSTimeInterval)duration
{
    CGFloat animationDistance = CGRectGetMaxY(view.frame);
    duration *= 0.9;
    CGFloat magnitude = (2 * animationDistance) / duration / duration / 1000;
    return magnitude;
}

- (void) animationFinished
{
    if (self.completion) {
        [self.animator removeAllBehaviors];
        self.animator = nil;
        self.completion();
    }
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self animationFinished];
}
@end
