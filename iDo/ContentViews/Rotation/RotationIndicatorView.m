//
//  RotationIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationIndicatorView.h"

#define ROTATION_INDICATOR_OUTAGE 20.f
#define CENTER_CIRCLE_RATIO 0.1f

@implementation RotationIndicatorView

#pragma mark - Set Up
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Public APIs
- (void) applyToView:(UIView *) view
{
    self.frame = CGRectInset(view.frame, ROTATION_INDICATOR_OUTAGE, ROTATION_INDICATOR_OUTAGE);
    [self setNeedsDisplay];
    self.hidden = YES;
}

- (void) show
{
    self.hidden = NO;
}

- (void) hide
{
    self.hidden = YES;
}

#pragma mark - Public APIs
- (void) drawRect:(CGRect)rect
{
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    
    UIBezierPath *horizontalLane = [UIBezierPath bezierPath];
    [horizontalLane moveToPoint:CGPointMake(0, midY)];
    [horizontalLane addLineToPoint:CGPointMake(maxX, midY)];

    UIBezierPath *verticalLane = [UIBezierPath bezierPath];
    [verticalLane moveToPoint:CGPointMake(midX, 0)];
    [verticalLane addLineToPoint:CGPointMake(midX, maxY)];
    
    CGFloat radius = MIN(rect.size.width, rect.size.height) * CENTER_CIRCLE_RATIO;
    UIBezierPath *centerCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midX, midY) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [[UIColor yellowColor] setStroke];
    [horizontalLane stroke];
    [verticalLane stroke];
    [centerCircle stroke];
}

@end
