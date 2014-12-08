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
    indicator.backgroundColor = [UIColor clearColor];
    return indicator;
}

- (UIColor *) fillColor
{
    return self.hasAnimation ? [UIColor yellowColor] : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
}

- (UIColor *) textColor
{
    return self.hasAnimation ? [UIColor darkTextColor] : [UIColor whiteColor];
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
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", self.animatinOrder] attributes:@{NSForegroundColorAttributeName : [self textColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [string drawInRect:rect];
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
