//
//  AnimationEditMenuItem.m
//  iDo
//
//  Created by Huang Hongsen on 12/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationEditMenuItem.h"
#import "AnimationOrderIndicatorView.h"
@interface AnimationEditMenuItem()

@property (nonatomic, strong) UILabel *animationTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) AnimationOrderIndicatorView *animationOrderIndicator;

@end
#define EDGE_SPACE 6.18
#define COMPONENT_DISTANCE 5
#define EDIT_MENU_ARROW_EDGE 30

@implementation AnimationEditMenuItem

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *)title
                      subTitle:(NSString *)subtitle
                      editMenu:(AnimationEditMenuView *)editMenu
                        action:(SEL)action
                          type:(EditMenuItemType)type
                  hasAnimation:(BOOL)hasAnimation
                animationOrder:(NSInteger) animationOrder
                animationEvent:(AnimationEvent)event
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _animationTitle = title;
        self.type = type;
        _hasAnimation = hasAnimation;
        
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:[self titleTextAttributes]];
        CGRect titleBounds = [attributedTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
        self.animationTitleLabel = [[UILabel alloc] initWithFrame:titleBounds];
        self.animationTitleLabel.attributedText = attributedTitle;
        self.animationTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.animationTitleLabel];
        if (subtitle) {
            NSAttributedString *attributedSubTitle = [[NSAttributedString alloc] initWithString:subtitle attributes:[self subTitleTextAttribtues]];
            CGRect subTitleBounds = [attributedSubTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
            self.subTitleLabel = [[UILabel alloc] initWithFrame:subTitleBounds];
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            self.subTitleLabel.attributedText = attributedSubTitle;
            [self addSubview:self.subTitleLabel];
        }
        self.animationOrderIndicator = [AnimationOrderIndicatorView animationOrderIndicatorForEvent:event];
        self.animationOrderIndicator.hasAnimation = NO;
        [self addSubview:self.animationOrderIndicator];
        [self layoutComponents];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchBegins) forControlEvents:(UIControlEventTouchDown | UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(touchEnds) forControlEvents:(UIControlEventTouchDragExit | UIControlEventTouchCancel)];
    }
    return self;
}

- (NSDictionary *) titleTextAttributes
{
    return @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}

- (NSDictionary *) subTitleTextAttribtues
{
    return @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.9 alpha:0.9], NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
}

- (void) touchBegins
{
    [super touchBegins];
    self.animationOrderIndicator.selected = YES;
}

- (void) touchEnds
{
    [super touchEnds];
    self.animationOrderIndicator.selected = NO;
}

- (void) restoreNormalState
{
    [super restoreNormalState];
    self.animationOrderIndicator.selected = NO;
}

- (void) setAnimationOrder:(NSInteger)animationOrder
{
    _animationOrder = animationOrder;
    self.animationOrderIndicator.animatinOrder = animationOrder;
}

- (void) setAnimationTitle:(NSString *)animationTitle
{
    _animationTitle = animationTitle;
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:animationTitle attributes:[self titleTextAttributes]];
    CGRect bounds = [attributedTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
    bounds.origin.y = 0;
    self.animationTitleLabel.bounds = bounds;
    self.animationTitleLabel.attributedText = attributedTitle;
    [self layoutComponents];
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
@end
