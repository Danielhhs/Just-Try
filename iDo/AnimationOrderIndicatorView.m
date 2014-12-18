//
//  AnimationOrderIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 12/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationOrderIndicatorView.h"
#import <CoreText/CoreText.h>

#define INDICATOR_EDGE_LENGTH 30
#define LEAD_SPACE 6.18

@implementation AnimationOrderIndicatorView

+ (AnimationOrderIndicatorView *) animationOrderIndicator
{
    AnimationOrderIndicatorView *indicator = [[self alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_EDGE_LENGTH, INDICATOR_EDGE_LENGTH)];
    return indicator;
}

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

- (void) setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay];
    }
}

- (UIColor *) fillColor
{
    if (self.selected) {
        return self.hasAnimation ? [UIColor yellowColor] : [UIColor colorWithRed:0.1 green:0.378431 blue:1 alpha:0.7];
    } else {
        return self.hasAnimation ? [UIColor yellowColor] : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
    }
}

- (UIColor *) textColor
{
    if (self.selected) {
        return self.hasAnimation ? [UIColor darkTextColor] : [UIColor colorWithWhite:1 alpha:0.8];
    } else {
        return self.hasAnimation ? [UIColor darkTextColor] : [UIColor whiteColor];
    }
}

- (void) setAnimatinOrder:(NSInteger)animatinOrder
{
    if (_animatinOrder != animatinOrder) {
        _animatinOrder = animatinOrder;
        self.hasAnimation = (animatinOrder == -1) ? NO : YES;
        [self setNeedsDisplay];
    }
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
    
    if (self.hasAnimation) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", self.animatinOrder] attributes:@{NSForegroundColorAttributeName : [self textColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
        CGRect boundingRect = [string boundingRectWithSize:CGSizeZero options:0 context:NULL];
        boundingRect.origin.y = 0;
        boundingRect.origin.x += (center.x - boundingRect.size.width / 2);
        boundingRect.origin.y += (center.y - boundingRect.size.height / 2);
        [string drawInRect:boundingRect];
    } else {
        CGFloat lineWidth = 3;
        UIBezierPath *horizontal = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(LEAD_SPACE, midY - lineWidth / 2, INDICATOR_EDGE_LENGTH - 2 * LEAD_SPACE, lineWidth) cornerRadius:lineWidth / 2];
        UIBezierPath *vertical = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(midX - lineWidth / 2, LEAD_SPACE, lineWidth, INDICATOR_EDGE_LENGTH - 2 * LEAD_SPACE) cornerRadius:lineWidth / 2];
        [[self textColor] setFill];
        [horizontal fill];
        [vertical fill];
    }
}

@end
