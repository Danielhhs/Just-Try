//
//  BorderControlPointView.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "BorderControlPointView.h"

@implementation BorderControlPointView

- (instancetype) initWithControlPointLocation:(ControlPointLocation)location
                                     delegate:(id<BorderControlPointViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, CONTROL_POINT_SIZE_HALF * 2, CONTROL_POINT_SIZE_HALF * 2)];
    if (self) {
        _location = location;
        _delegate = delegate;
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
        CGPoint position = [gesture locationInView:[self.delegate containerView]];
        [self.delegate controlPoint:self didMoveByTranslation:translation atPosition:position];
        [gesture setTranslation:CGPointZero inView:[self.delegate containerView]];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.delegate controlPointDidFinishMoving:self];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:center radius:CONTROL_POINT_RADIUS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor greenColor] setFill];
    [circle fill];
}


@end
