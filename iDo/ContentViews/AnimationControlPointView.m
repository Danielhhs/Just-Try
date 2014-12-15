//
//  AnimationControlPointView.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationControlPointView.h"
@interface AnimationControlPointView()
@property (nonatomic, strong) UILabel *animateInOrderLabel;
@property (nonatomic, strong) UILabel *animateOutOrderLabel;
@end
#define kAnimationControlPointHeight 30
@implementation AnimationControlPointView
#pragma mark - Initialization
- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.animateInOrderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.animateInOrderLabel.textAlignment = NSTextAlignmentCenter;
    self.animateOutOrderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.animateOutOrderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.animateOutOrderLabel];
    [self addSubview:self.animateInOrderLabel];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Business Logic

- (void) setAnimateInOrder:(NSInteger)animateInOrder
{
    _animateInOrder = animateInOrder;
    self.animateInOrderLabel.text = [NSString stringWithFormat:@"%lu", animateInOrder];
    [self layoutAnimationOrderLabels];
    [self setNeedsDisplay];
}

- (void) setAnimateOutOrder:(NSInteger)animateOutOrder
{
    _animateOutOrder = animateOutOrder;
    self.animateOutOrderLabel.text = [NSString stringWithFormat:@"%lu", animateOutOrder];
    [self layoutAnimationOrderLabels];
    [self setNeedsDisplay];
}

- (NSInteger) numberOfAnimations
{
    if (self.animateInOrder == -1 && self.animateOutOrder == -1) {
        return 0;
    } else if (self.animateOutOrder == -1 || self.animateInOrder == -1) {
        return 1;
    } else {
        return 2;
    }
}

- (void) layoutAnimationOrderLabels
{
    if ([self numberOfAnimations] == 1) {
        self.bounds = CGRectMake(0, 0, kAnimationControlPointHeight, kAnimationControlPointHeight);
        if (self.animateInOrder == -1) {
            self.animateOutOrderLabel.frame = self.bounds;
            self.animateOutOrderLabel.hidden = NO;
            self.animateInOrderLabel.hidden = YES;
        } else {
            self.animateInOrderLabel.frame = self.bounds;
            self.animateInOrderLabel.hidden = NO;
            self.animateOutOrderLabel.hidden = YES;
        }
    } else if ([self numberOfAnimations] == 2) {
        self.bounds = CGRectMake(0, 0, kAnimationControlPointHeight * 2, kAnimationControlPointHeight);
        self.animateInOrderLabel.frame = CGRectMake(0, 0, kAnimationControlPointHeight, kAnimationControlPointHeight);
        self.animateInOrderLabel.hidden = NO;
        self.animateOutOrderLabel.frame = CGRectMake(kAnimationControlPointHeight, 0, kAnimationControlPointHeight, kAnimationControlPointHeight);
        self.animateOutOrderLabel.hidden = NO;
    } else {
        self.bounds = CGRectZero;
        self.animateInOrderLabel.hidden = YES;
        self.animateOutOrderLabel.hidden = YES;
    }
}

#pragma mark - Drawing
- (UIBezierPath *) singleAnimationFillPath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kAnimationControlPointHeight / 2, kAnimationControlPointHeight / 2) radius:kAnimationControlPointHeight / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return path;
}

- (UIBezierPath *)animateInFillPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(kAnimationControlPointHeight / 2, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, kAnimationControlPointHeight)];
    [path addLineToPoint:CGPointMake(kAnimationControlPointHeight / 2, kAnimationControlPointHeight)];
    [path addArcWithCenter:CGPointMake(kAnimationControlPointHeight / 2, kAnimationControlPointHeight / 2) radius:kAnimationControlPointHeight / 2 startAngle:M_PI / 2 endAngle:M_PI * 1.5 clockwise:YES];
    return path;
}

- (UIBezierPath *) animateOutFillPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - kAnimationControlPointHeight / 2, 0)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width - kAnimationControlPointHeight / 2, kAnimationControlPointHeight / 2) radius:kAnimationControlPointHeight / 2 startAngle:-M_PI / 2 endAngle:M_PI / 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, kAnimationControlPointHeight)];
    [path closePath];
    return path;
}

- (UIColor *) animateInColor
{
    return [UIColor yellowColor];
}

- (UIColor *) animateOutColor
{
    return [UIColor grayColor];
}

- (UIColor *) singleFillColor
{
    if (self.animateInOrder == -1) {
        return [self animateOutColor];
    } else {
        return [self animateInColor];
    }
}

- (void) drawRect:(CGRect)rect
{
    if ([self numberOfAnimations] == 1) {
        UIBezierPath *path = [self singleAnimationFillPath];
        [[self singleFillColor] setFill];
        [path fill];
    } else if ([self numberOfAnimations] == 2) {
        UIBezierPath *leftPath = [self animateInFillPath];
        [[self animateInColor] setFill];
        [leftPath fill];
        UIBezierPath *rightPath = [self animateOutFillPath];
        [[self animateOutColor] setFill];
        [rightPath fill];
    }
}

@end
