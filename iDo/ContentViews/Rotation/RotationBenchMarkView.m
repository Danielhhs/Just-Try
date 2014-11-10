//
//  RotationBenchMarkView.m
//  iDo
//
//  Created by Huang Hongsen on 10/31/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RotationBenchMarkView.h"

#define ROTATION_INDICATOR_OUTAGE 40.f

@implementation RotationBenchMarkView

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

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGAffineTransformIsIdentity(self.transform)) {
        [self setNeedsDisplay];
    }
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void) drawRect:(CGRect)rect
{
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    UIBezierPath *horizontalLane = [UIBezierPath bezierPath];
    [horizontalLane moveToPoint:CGPointMake(0, midY)];
    [horizontalLane addLineToPoint:CGPointMake(maxX, midY)];
    CGFloat lineDash[] = {5., 2.};
    [horizontalLane setLineDash:lineDash count:2 phase:0];
    
    UIBezierPath *verticalLane = [UIBezierPath bezierPath];
    [verticalLane moveToPoint:CGPointMake(midX, 0)];
    [verticalLane addLineToPoint:CGPointMake(midX, maxY)];
    [verticalLane setLineDash:lineDash count:2 phase:0];
    
    [[UIColor yellowColor] setStroke];
    [horizontalLane stroke];
    [verticalLane stroke];
}

@end
