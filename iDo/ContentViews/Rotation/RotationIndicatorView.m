//
//  RotationIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationIndicatorView.h"
#import "RotationBenchMarkView.h"
#import "RotationTooltipView.h"

#define ROTATION_INDICATOR_OUTAGE 40.f
#define CENTER_CIRCLE_RADIUS 10.f
#define TOOLTIP_WIDTH_HALF 35.f
#define ANGELS_PER_PI 180
@interface RotationIndicatorView ()
@property (nonatomic, strong) RotationTooltipView *tooltip;
@property (nonatomic, strong) RotationBenchMarkView *benchMark;
@end

@implementation RotationIndicatorView

#pragma mark - Set Up
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.benchMark = [[RotationBenchMarkView alloc] initWithFrame:self.bounds];
    [self addSubview:self.benchMark];
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
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.benchMark.frame = self.bounds;
    if (CGAffineTransformIsIdentity(self.transform)) {
        [self setNeedsDisplay];
    }
}

- (void) applyToView:(UIView *) view
{
    self.frame = CGRectInset(view.bounds, -ROTATION_INDICATOR_OUTAGE, -ROTATION_INDICATOR_OUTAGE);
    self.hidden = YES;
}

- (void) update
{
    self.hidden = NO;
    self.benchMark.transform = CGAffineTransformInvert(self.superview.transform);
    self.tooltip.toolTipText = [NSString stringWithFormat:@"%3.3g∘", [self rotationDegree]];
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
    
    UIBezierPath *centerCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(midX, midY) radius:CENTER_CIRCLE_RADIUS startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [[UIColor yellowColor] setStroke];
    horizontalLane.lineWidth = 2.f;
    verticalLane.lineWidth = 2.f;
    centerCircle.lineWidth = 2.f;
    [horizontalLane stroke];
    [verticalLane stroke];
    [centerCircle stroke];
}

#pragma mark - Private Helper
- (CGRect) tooltipFrame
{
    CGRect frame;
    frame.origin.x = CGRectGetMidX(self.bounds);
    frame.origin.y = 0;
    frame.size.width = TOOLTIP_WIDTH_HALF * 2;
    frame.size.height = ROTATION_INDICATOR_OUTAGE;
    return frame;
}

- (CGFloat) rotationDegree
{
    CGAffineTransform transform = [self.superview transform];
    CGFloat radians = atan2f(transform.b, transform.a);
    return radians * ANGELS_PER_PI / M_PI;
}

@end