//
//  RotationIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationIndicatorView.h"
#import "RotationTooltipView.h"
#import "DrawingConstants.h"

#define ROTATION_INDICATOR_OUTAGE 40.f
#define CENTER_CIRCLE_RADIUS 10.f
#define TOOLTIP_WIDTH_HALF 35.f

@interface RotationIndicatorView ()
@property (nonatomic, strong) RotationTooltipView *tooltip;
@end

@implementation RotationIndicatorView

#pragma mark - Set Up
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    CGRect tooltipFrame = [self tooltipFrame];
    self.tooltip = [[RotationTooltipView alloc] initWithFrame:tooltipFrame];
    [self addSubview:self.tooltip];
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
    self.frame = view.bounds;
}

- (void) update
{
    self.tooltip.frame = [self tooltipFrame];
    self.tooltip.toolTipText = [NSString stringWithFormat:@"%3.3g∘", [self rotationDegree]];
}

- (void) hide
{
    [self removeFromSuperview];
}

#pragma mark - Public APIs
- (void) drawRect:(CGRect)rect
{
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);

    UIBezierPath *verticalLane = [UIBezierPath bezierPath];
    [verticalLane moveToPoint:CGPointMake(midX, midY)];
    [verticalLane addLineToPoint:CGPointMake(midX, midY - 50)];
    
    UIBezierPath *centerCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midX, midY) radius:CENTER_CIRCLE_RADIUS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor yellowColor] setStroke];
    verticalLane.lineWidth = 2.f;
    centerCircle.lineWidth = 2.f;
    [verticalLane stroke];
    [centerCircle stroke];
}

#pragma mark - Private Helper
- (CGRect) tooltipFrame
{
    CGRect frame;
    frame.origin.x = CGRectGetMidX(self.bounds) - TOOLTIP_WIDTH_HALF;
    frame.origin.y = -1 * ROTATION_INDICATOR_OUTAGE;
    frame.size.width = TOOLTIP_WIDTH_HALF * 2;
    frame.size.height = ROTATION_INDICATOR_OUTAGE;
    return frame;
}

- (CGFloat) rotationDegree
{
    CGAffineTransform transform = [self.superview transform];
    CGFloat radians = atan2f(transform.b, transform.a);
    return radians * [DrawingConstants angelsPerPi] / M_PI;
}

@end
