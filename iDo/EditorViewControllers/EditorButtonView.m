//
//  EditorButtonView.m
//  iDo
//
//  Created by Huang Hongsen on 10/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorButtonView.h"
@interface EditorButtonView()
@end


@implementation EditorButtonView

#pragma mark - Initialization
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void) setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (UIColor *) fillColor {
    UIColor *fillColor = nil;
    if (self.selected) {
        fillColor = [UIColor colorWithWhite:1.f alpha:0.8];
    } else {
        fillColor = [UIColor colorWithWhite:0.2 alpha:0.372];
    }
    return fillColor;
}

- (void) drawRect:(CGRect)rect
{
    CGFloat radius = CGRectGetMidX(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [path addClip];
    [[self fillColor] setFill];
    [path fill];
}

@end
