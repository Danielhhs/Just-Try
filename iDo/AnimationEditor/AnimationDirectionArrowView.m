//
//  AnimationDirectionArrowView.m
//  iDo
//
//  Created by Huang Hongsen on 12/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationDirectionArrowView.h"

@interface AnimationDirectionArrowView ()
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end
#define kArrowDepth 10

#define kArrowWidth 10
@implementation AnimationDirectionArrowView

- (instancetype) initWithFrame:(CGRect)frame direction:(AnimationPermittedDirection) direction delegate:(id<AnimationDirectionArrowViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.direction = direction;
        self.delegate = delegate;
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:self.tap];
        self.tap.enabled = NO;
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void) setAllowed:(BOOL)allowed
{
    _allowed = allowed;
    if (allowed) {
        self.tap.enabled = YES;
    } else {
        self.tap.enabled = NO;
    }
    [self setNeedsDisplay];
}

- (void) handleTap:(UITapGestureRecognizer *) tap
{
    self.selected = YES;
    [self.delegate didSelectDirection:self.direction];
}

- (CGFloat) lineWidth
{
    return self.selected ? 3.5 : 1.5;
}

- (UIColor *) strokeColor
{
    return self.allowed ? self.tintColor : [UIColor lightGrayColor];
}

- (void) drawVerticalArrowsInContext:(CGContextRef) context inRect:(CGRect)rect
{
    if (self.direction == AnimationPermittedDirectionBottom) {
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1, -1);
    }
    CGContextMoveToPoint(context, rect.size.width / 2, 0);
    CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width / 2 - kArrowWidth, rect.size.height - kArrowDepth);
    CGContextMoveToPoint(context, rect.size.width / 2, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width / 2 + kArrowWidth, rect.size.height - kArrowDepth);
    CGContextSetLineWidth(context, [self lineWidth]);
    [[self strokeColor] setStroke];
    CGContextStrokePath(context);
}

- (void) drawHorizontalArrowsInContext:(CGContextRef) context inRect:(CGRect) rect
{
    if (self.direction == AnimationPermittedDirectionRight) {
        CGContextTranslateCTM(context, rect.size.width, 0);
        CGContextScaleCTM(context, -1, 1);
    }
    CGContextMoveToPoint(context, 0, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width - kArrowDepth, rect.size.height / 2 - kArrowWidth);
    CGContextMoveToPoint(context, rect.size.width, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width - kArrowDepth, rect.size.height / 2 + kArrowWidth);
    CGContextSetLineWidth(context, [self lineWidth]);
    [[self strokeColor] setStroke];
    CGContextStrokePath(context);
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.direction == AnimationPermittedDirectionUp || self.direction == AnimationPermittedDirectionBottom) {
        [self drawVerticalArrowsInContext:context inRect:rect];
    } else  if (self.direction == AnimationPermittedDirectionLeft || self.direction == AnimationPermittedDirectionRight) {
        [self drawHorizontalArrowsInContext:context inRect:rect];
    }
}

@end
