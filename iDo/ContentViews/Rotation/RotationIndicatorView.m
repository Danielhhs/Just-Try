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
@property (nonatomic) BOOL corrected;
@property (nonatomic, strong) UIBezierPath *correctedVerticalLane;
@property (nonatomic, strong) UIBezierPath *nonCorrectedVerticalLane;
@end

@implementation RotationIndicatorView

#pragma mark - Set Up
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.tooltip = [[RotationTooltipView alloc] initWithFrame:CGRectZero];
    [self updateTooltip];
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
    [self updateTooltip];
    [self updateCorrected];
    [self setNeedsDisplay];
}

- (void) updateTooltip
{
    self.tooltip.bounds = CGRectMake(0, 0, TOOLTIP_WIDTH_HALF * 2, ROTATION_INDICATOR_OUTAGE);
    self.tooltip.center = CGPointMake(CGRectGetMidX(self.bounds), -1 * ROTATION_INDICATOR_OUTAGE);
}

- (void) update
{
    [self updateCorrected];
    self.tooltip.transform = CGAffineTransformInvert(self.superview.transform);
    self.tooltip.toolTipText = [NSString stringWithFormat:@"%3.3g∘", [self rotationDegree]];
}

- (void) updateCorrected
{
    NSInteger angle = (NSInteger)[self rotationDegree];
    if (angle % 45 == 0) {
        self.corrected = YES;
    } else {
        self.corrected = NO;
    }
}

- (void) setCorrected:(BOOL)corrected
{
    if (_corrected != corrected) {
        _corrected = corrected;
        [self setNeedsDisplay];
    }
}

- (UIColor *) strokeColor
{
    return self.corrected ? [UIColor yellowColor] : [UIColor colorWithRed:1 green:1 blue:0 alpha:0.7];
}

- (void) hide
{
    [self removeFromSuperview];
}

- (UIBezierPath *) correctedVerticalLane
{
    if (!_correctedVerticalLane) {
        _correctedVerticalLane = [UIBezierPath bezierPath];
        [_correctedVerticalLane moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [_correctedVerticalLane addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), 0)];
    }
    return _correctedVerticalLane;
}

- (UIBezierPath *) nonCorrectedVerticalLane
{
    if (!_nonCorrectedVerticalLane) {
        _nonCorrectedVerticalLane = [UIBezierPath bezierPath];
        [_nonCorrectedVerticalLane moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [_nonCorrectedVerticalLane addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), 0)];
        CGFloat lineDash[2] = {5.0, 3.0};
        [_nonCorrectedVerticalLane setLineDash:lineDash count:2 phase:1];
    }
    return _nonCorrectedVerticalLane;
}

- (UIBezierPath *) verticalLane
{
    return self.corrected ? self.correctedVerticalLane : self.nonCorrectedVerticalLane;
}

#pragma mark - Public APIs
- (void) drawRect:(CGRect)rect
{
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);

    UIBezierPath *verticalLane = [self verticalLane];
    
    UIBezierPath *centerCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midX, midY) radius:CENTER_CIRCLE_RADIUS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[self strokeColor] setStroke];
    verticalLane.lineWidth = 1.5f;
    centerCircle.lineWidth = 1.5f;
    [verticalLane stroke];
    [centerCircle stroke];
}

#pragma mark - Private Helper
- (CGFloat) rotationDegree
{
    CGAffineTransform transform = [self.superview transform];
    CGFloat radians = atan2f(transform.b, transform.a);
    return radians * [DrawingConstants angelsPerPi] / M_PI;
}

@end
