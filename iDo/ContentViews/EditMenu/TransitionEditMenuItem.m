//
//  TransitionEditMenuItem.m
//  iDo
//
//  Created by Huang Hongsen on 12/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TransitionEditMenuItem.h"
#import "TransitionIndicatorView.h"
#import "TransitionEditMenuView.h"
#define kTransitionEditMenuItemArrowHeight 30
#define kTransitionEditMenuItemComponentSpace 10
@interface TransitionEditMenuItem()
@property (nonatomic, strong) TransitionIndicatorView *transitionIndicator;
@end

@implementation TransitionEditMenuItem

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *)title
                      editMenu:(TransitionEditMenuView *)editMenu
                        action:(SEL)action
                  hasAnimation:(BOOL)hasAnimation
{
    self = [super initWithFrame:frame title:title editMenu:editMenu action:action];
    if (self) {
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:[self titleAttributes]] forState:UIControlStateNormal];
        self.transitionIndicator = [[TransitionIndicatorView alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_EDGE_LENGTH, INDICATOR_EDGE_LENGTH)];
        self.animationTitle = title;
        [self addSubview:self.transitionIndicator];
    }
    return self;
}

- (NSDictionary *) titleAttributes
{
    return @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void) setAnimationTitle:(NSString *)animationTitle
{
    _animationTitle = animationTitle;
    
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:animationTitle attributes:[self titleAttributes]];
    CGRect boundingRect = [attrTitle boundingRectWithSize:CGSizeZero options:0 context:nil];
    self.transitionIndicator.frame = CGRectMake(kTransitionEditMenuItemArrowHeight + boundingRect.size.width + 2 *kTransitionEditMenuItemComponentSpace, (self.frame.size.height - INDICATOR_EDGE_LENGTH) / 2, INDICATOR_EDGE_LENGTH, INDICATOR_EDGE_LENGTH);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetMaxX(self.transitionIndicator.frame) + 5, self.frame.size.height);
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {
    CGFloat midY = CGRectGetMidY(rect);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, midY)];
    [path addLineToPoint:CGPointMake(kTransitionEditMenuItemArrowHeight, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [path addLineToPoint:CGPointMake(kTransitionEditMenuItemArrowHeight, CGRectGetMaxY(rect))];
    [path closePath];
    [[self fillColor] setFill];
    [path fill];
}

@end
