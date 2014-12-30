//
//  AnimationIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 12/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationIndicatorView.h"

#define LEAD_SPACE 6.18
@implementation AnimationIndicatorView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.selected = YES;
}

- (void) handleTap:(UITapGestureRecognizer *) tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        self.selected = NO;
    }
}

- (UIColor *) fillColor
{
    return [UIColor clearColor];
}

- (UIColor *) textColor
{
    return [UIColor clearColor];
}

- (void) drawIndicatorShape
{
    
}

- (void) drawPlus
{
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat lineWidth = 3;
    UIBezierPath *horizontal = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LEAD_SPACE, midY - lineWidth / 2, INDICATOR_EDGE_LENGTH - 2 * LEAD_SPACE, lineWidth) cornerRadius:lineWidth / 2];
    UIBezierPath *vertical = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(midX - lineWidth / 2, LEAD_SPACE, lineWidth, INDICATOR_EDGE_LENGTH - 2 * LEAD_SPACE) cornerRadius:lineWidth / 2];
    [[self textColor] setFill];
    [horizontal fill];
    [vertical fill];
}

- (void) drawRect:(CGRect)rect
{
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGPoint center = CGPointMake(midX, midY);
    UIBezierPath *backgroudnCircle = [UIBezierPath bezierPathWithArcCenter:center radius:rect.size.width / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[UIColor whiteColor] setFill];
    [backgroudnCircle fill];
    
    UIBezierPath *contentCircle = [UIBezierPath bezierPathWithArcCenter:center radius:rect.size.width / 2 - 1.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [[self fillColor] setFill];
    [contentCircle fill];
    
    [self drawIndicatorShape];
}

@end
