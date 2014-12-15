//
//  BorderControlPointView.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "BorderControlPointView.h"
#import "ControlPointManager.h"
#import "DrawingConstants.h"
#define CONTROL_POINT_SMALL_CIRCLE_RADIUS 5.f

@implementation BorderControlPointView

- (instancetype) initWithControlPointLocation:(ControlPointLocation)location
                                     delegate:(id<BorderControlPointViewDelegate>)delegate
                                        color:(UIColor *)fillColor
{
    self = [super initWithFrame:CGRectMake(0, 0, [DrawingConstants controlPointSizeHalf] * 2, [DrawingConstants controlPointSizeHalf] * 2)];
    if (self) {
        _location = location;
        _delegate = delegate;
        _fillColor = fillColor;
        self.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(locationChanged:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void) locationChanged:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.delegate controlPointDidStartMoving:self];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:[self.delegate containerView]];
        CGPoint translationInSuperview = [gesture translationInView:[self.delegate containerView].superview];
        [self.delegate controlPoint:self didMoveByTranslation:translation translationInSuperView:translationInSuperview];
        [gesture setTranslation:CGPointZero inView:[self.delegate containerView]];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.delegate controlPointDidFinishMoving:self];
    }
}

- (void) setFillColor:(UIColor *)fillColor
{
    if (![_fillColor isEqual:fillColor]) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithArcCenter:center radius:[DrawingConstants controlPointRadius] startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor whiteColor] setFill];
    [bigCircle fill];
    
    UIBezierPath *smallCircle = [UIBezierPath bezierPathWithArcCenter:center radius:CONTROL_POINT_SMALL_CIRCLE_RADIUS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[[ControlPointManager sharedManager] borderColor] setFill];
    [smallCircle fill];
}


@end
