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
#import "AnimationOrderIndicatorView.h"
@interface EditMenuItem()
@property (nonatomic, weak) ContentEditMenuView *editMenu;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UILabel *animationTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) AnimationOrderIndicatorView *animationOrderIndicator;
@end

#define ROUND_RECT_CORNOR_RADIUS 10
#define EDGE_SPACE 6.18
#define COMPONENT_DISTANCE 5
#define EDIT_MENU_ARROW_EDGE 30

@implementation EditMenuItem

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(ContentEditMenuView *) editMenu
                        action:(SEL) action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:[DrawingConstants goldenRatio]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchBegins) forControlEvents:(UIControlEventTouchDown | UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(touchEnds) forControlEvents:(UIControlEventTouchDragExit | UIControlEventTouchCancel)];
        [self adjustButtonWidth];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *)title
                      subTitle:(NSString *)subtitle
                      editMenu:(ContentEditMenuView *)editMenu
                        action:(SEL)action
                          type:(EditMenuItemType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _animationTitle = title;
        _type = type;
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
        CGRect titleBounds = [attributedTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
        self.animationTitleLabel = [[UILabel alloc] initWithFrame:titleBounds];
        self.animationTitleLabel.attributedText = attributedTitle;
        self.animationTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.animationTitleLabel];
        if (subtitle) {
            NSAttributedString *attributedSubTitle = [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:0.9], NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
            CGRect subTitleBounds = [attributedSubTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
            self.subTitleLabel = [[UILabel alloc] initWithFrame:subTitleBounds];
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            self.subTitleLabel.attributedText = attributedSubTitle;
            [self addSubview:self.subTitleLabel];
        }
        self.animationOrderIndicator = [AnimationOrderIndicatorView animationOrderIndicator];
        self.animationOrderIndicator.hasAnimation = NO;
        [self addSubview:self.animationOrderIndicator];
        [self layoutComponents];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchBegins) forControlEvents:(UIControlEventTouchDown | UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(touchEnds) forControlEvents:(UIControlEventTouchDragExit | UIControlEventTouchCancel)];
    }
    return self;
}

- (void) adjustButtonWidth
{
    CGSize sizeThatFits = [self sizeThatFits:self.bounds.size];
    CGRect bounds = self.bounds;
    bounds.size.width = sizeThatFits.width + 20;
    self.bounds = bounds;
}

- (void) touchBegins
{
    self.fillColor = [UIColor colorWithWhite:0.2 alpha:0.7];
}

- (void) touchEnds
{
    self.fillColor = [EditMenuItem normalStateColor];
}

+ (UIColor *) normalStateColor
{
    return [UIColor colorWithWhite:0 alpha:0.9];
}

- (void) restoreNormalState
{
    self.fillColor = [EditMenuItem normalStateColor];
}

- (void) setType:(EditMenuItemType)type
{
    if (_type != type) {
        _type = type;
        [self setNeedsDisplay];
    }
}

- (void) layoutComponents
{
    CGFloat titleAreaWidth = MAX(self.animationTitleLabel.bounds.size.width, self.subTitleLabel.bounds.size.width) + COMPONENT_DISTANCE * 2;
    CGFloat insetWidth = (self.type == EditMenuItemTypeRightArrow || self.type == EditMenuItemTypeLeftArrow) ? EDIT_MENU_ARROW_EDGE : EDGE_SPACE;
    self.bounds = CGRectMake(0, 0, titleAreaWidth + insetWidth + self.animationOrderIndicator.bounds.size.width + COMPONENT_DISTANCE, self.animationTitleLabel.bounds.size.height + self.subTitleLabel.bounds.size.height + 2 * EDGE_SPACE + COMPONENT_DISTANCE);
    if (self.type == EditMenuItemTypeLeftArrow || self.type == EditMenuItemTypeRightMost) {
        self.animationTitleLabel.center = CGPointMake(titleAreaWidth / 2, CGRectGetMidY(self.animationTitleLabel.bounds) + EDGE_SPACE);
        self.subTitleLabel.center = CGPointMake(titleAreaWidth / 2, self.animationTitleLabel.bounds.size.height + CGRectGetMidY(self.subTitleLabel.bounds) + COMPONENT_DISTANCE + EDGE_SPACE);
        self.animationOrderIndicator.center = CGPointMake(titleAreaWidth + CGRectGetMidX(self.animationOrderIndicator.bounds), CGRectGetMidY(self.bounds));
    } else if (self.type == EditMenuItemTypeRightArrow || self.type == EditMenuItemTypeLeftMost) {
        self.animationTitleLabel.center = CGPointMake(EDGE_SPACE + insetWidth + self.animationOrderIndicator.bounds.size.width + titleAreaWidth / 2, CGRectGetMidY(self.animationTitleLabel.bounds) + EDGE_SPACE);
        self.subTitleLabel.center = CGPointMake(EDGE_SPACE + insetWidth + self.animationOrderIndicator.bounds.size.width + titleAreaWidth / 2, self.animationTitleLabel.bounds.size.height + CGRectGetMidY(self.subTitleLabel.bounds) + COMPONENT_DISTANCE + EDGE_SPACE);
        self.animationOrderIndicator.center = CGPointMake(EDGE_SPACE + insetWidth + CGRectGetMidX(self.animationOrderIndicator.bounds), CGRectGetMidY(self.bounds));
    }
    [self setNeedsDisplay];
}

- (void) setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void) setAnimationTitle:(NSString *)animationTitle
{
    if (![animationTitle isEqualToString:_animationTitle]) {
        _animationTitle = animationTitle;
        [self layoutComponents];
    }
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
        case EditMenuItemTypeLeftArrow:
            fillPath = [self fillPathForLeftArrowType];
            break;
        case EditMenuItemTypeRightArrow:
            fillPath = [self fillPathForRightArrowType];
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

- (UIBezierPath *) fillPathForLeftArrowType
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat midY = CGRectGetMidY(self.bounds);
    [path moveToPoint:CGPointMake(0, midY)];
    [path addLineToPoint:CGPointMake(EDIT_MENU_ARROW_EDGE, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(EDIT_MENU_ARROW_EDGE, self.bounds.size.height)];
    [path closePath];
    return path;
}

- (UIBezierPath *) fillPathForRightArrowType
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat midY = CGRectGetMidY(self.bounds);
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - EDIT_MENU_ARROW_EDGE, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, midY)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - EDIT_MENU_ARROW_EDGE, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [path closePath];
    return path;
}


- (void) drawRect:(CGRect)rect
{
    UIBezierPath *path = [self fillPath];
    [[self fillColor] setFill];
    [path fill];
}

@end
