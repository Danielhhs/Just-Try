//
//  EditMenuItem.m
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuItem.h"
#import "ContentEditMenuView.h"
#import "DrawingConstants.h"
@interface EditMenuItem()
@property (nonatomic, weak) ContentEditMenuView *editMenu;
@property (nonatomic) EditMenuItemType type;
@property (nonatomic, strong) UIColor *fillColor;
@end

#define ROUND_RECT_CORNOR_RADIUS 10

@implementation EditMenuItem

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(ContentEditMenuView *) editMenu
                        action:(SEL) action
                          type:(EditMenuItemType) type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:[DrawingConstants goldenRatio]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchBegins) forControlEvents:(UIControlEventTouchDown | UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(touchEnds) forControlEvents:(UIControlEventTouchDragExit | UIControlEventTouchCancel)];
    }
    return self;
}

- (void) touchBegins
{
    self.fillColor = [UIColor colorWithWhite:0.1 alpha:0.7];
}

- (void) touchEnds
{
    self.fillColor = [EditMenuItem normalStateColor];
}

+ (UIColor *) normalStateColor
{
    return [UIColor colorWithWhite:0 alpha:0.9];
}

- (void) setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (UIBezierPath *) fillPath
{
    UIBezierPath *fillPath = nil;
    switch (self.type) {
        case EditMenuItemTypeCommon:
            fillPath = [UIBezierPath bezierPathWithRect:self.bounds];
            break;
        case EditMenuItemTypeLeftMost:
            fillPath = [self fillPathForLeftMostType];
            break;
        case EditMenuItemTypeOnly:
            fillPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:ROUND_RECT_CORNOR_RADIUS];
            break;
        case EditMenuItemTypeRightMost:
            fillPath = [self fillPathForRightMostType];
            break;
        default:
            break;
    }
    return fillPath;
}

- (UIBezierPath *) fillPathForLeftMostType
{
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointMake(ROUND_RECT_CORNOR_RADIUS, 0)];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [fillPath addLineToPoint:CGPointMake(ROUND_RECT_CORNOR_RADIUS, self.bounds.size.height)];
    [fillPath addArcWithCenter:CGPointMake(ROUND_RECT_CORNOR_RADIUS, self.bounds.size.height - ROUND_RECT_CORNOR_RADIUS) radius:ROUND_RECT_CORNOR_RADIUS startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    [fillPath addLineToPoint:CGPointMake(0, ROUND_RECT_CORNOR_RADIUS)];
    [fillPath addArcWithCenter:CGPointMake(ROUND_RECT_CORNOR_RADIUS, ROUND_RECT_CORNOR_RADIUS) radius:ROUND_RECT_CORNOR_RADIUS startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    return fillPath;
}

- (UIBezierPath *) fillPathForRightMostType
{
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [fillPath moveToPoint:CGPointZero];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width - ROUND_RECT_CORNOR_RADIUS, 0)];
    [fillPath addArcWithCenter:CGPointMake(self.bounds.size.width - ROUND_RECT_CORNOR_RADIUS, ROUND_RECT_CORNOR_RADIUS) radius:ROUND_RECT_CORNOR_RADIUS startAngle:M_PI * 1.5 endAngle:M_PI * 2 clockwise:YES];
    [fillPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - ROUND_RECT_CORNOR_RADIUS)];
    [fillPath addArcWithCenter:CGPointMake(self.bounds.size.width - ROUND_RECT_CORNOR_RADIUS, self.bounds.size.height - ROUND_RECT_CORNOR_RADIUS) radius:ROUND_RECT_CORNOR_RADIUS startAngle:0 endAngle:M_PI / 2 clockwise:YES];
    [fillPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [fillPath addLineToPoint:CGPointZero];
    return fillPath;
}


- (void) drawRect:(CGRect)rect
{
    UIBezierPath *path = [self fillPath];
    [[self fillColor] setFill];
    [path fill];
}

@end
