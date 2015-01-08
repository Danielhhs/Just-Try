//
//  AnimationEditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationEditMenuView.h"
#import "AnimationEditMenuItem.h"
#import "AnimationAttributesHelper.h"
#import "GenericContainerView.h"

#define EDIT_MENU_ARROW_HEIGHT 10
#define EDIT_MENU_ARROW_WIDTH_HALF 10
#define EDIT_MENU_CORNER_RADIUS 10
#define SEPARATOR_TOP_BOTTOM_MARGIN 5

@interface AnimationEditMenuView()

@property (nonatomic, strong) AnimationEditMenuItem *animateInButton;
@property (nonatomic, strong) AnimationEditMenuItem *animateOutButton;
@property (nonatomic, strong) GenericContainerView *triggeredContent;
@property (nonatomic, strong) NSMutableArray *operations;
@end

@implementation AnimationEditMenuView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _animateInButton = [[AnimationEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants noneText] subTitle:[TextConstants animateInText] editMenu:self action:@selector(handleAnimateIn) type:EditMenuItemTypeLeftMost hasAnimation:YES animationOrder:1 animationEvent:AnimationEventBuiltIn];
        _animateOutButton = [[AnimationEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants noneText] subTitle:[TextConstants animateOutText] editMenu:self action:@selector(handleAnimateOut) type:EditMenuItemTypeRightMost hasAnimation:NO animationOrder:0 animationEvent:AnimationEventBuiltOut];
        self.itemHeight = _animateOutButton.frame.size.height;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSMutableArray *) operations
{
    if (!_operations) {
        _operations = [NSMutableArray arrayWithObjects:self.animateInButton, self.animateOutButton, nil];
        self.availableOperations = _operations;
    }
    return _operations;
}

- (void) handleAnimateIn
{
    self.currentSelectedItem = self.animateInButton;
    [self.delegate editMenu:self willShowAnimationEditorForContent:self.triggeredContent forType:AnimationEventBuiltIn];
    [self.animateInButton restoreNormalState];
}

- (void) handleAnimateOut
{
    self.currentSelectedItem = self.animateOutButton;
    [self.delegate editMenu:self willShowAnimationEditorForContent:self.triggeredContent forType:AnimationEventBuiltOut];
    [self.animateOutButton restoreNormalState];
}

- (void) updateAnimationOrderIndicatorsForContent:(GenericContainerView *) content
{
    NSInteger animationOrder = [AnimationAttributesHelper animationOrderForAttributes:[content attributes] event:AnimationEventBuiltIn];
    [self.animateInButton setAnimationOrder:animationOrder];
    animationOrder = [AnimationAttributesHelper animationOrderForAttributes:[content attributes] event:AnimationEventBuiltOut];
    [self.animateOutButton setAnimationOrder:animationOrder];
}

- (void) showToContent:(GenericContainerView *)content animated:(BOOL) animated
{
    self.animateInButton.animationTitle = [AnimationAttributesHelper animationInTitleForContent:content];
    self.animateOutButton.animationTitle = [AnimationAttributesHelper animationOutTitleForContent:content];
    [self updateAnimationOrderIndicatorsForContent:content];
    self.triggeredContent = content;
    self.trigger = content;
    for (NSInteger i = 0; i < [self.operations count]; i++) {
        EditMenuItem *item = self.operations[i];
        item.type = [self itemTypeForButtonItem:item index:i totalItems:[self.operations count]];
        [self addSubview:item];
    }
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    self.alpha = 1;
    if (animated) {
        self.alpha = 0;
        [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
            self.alpha = 1;
        }];
    }
    [self setNeedsDisplay];
}

- (void) updateEditAnimationItemWithAnimationName:(NSString *)animationName animationOrder:(NSInteger) animationOrder
{
    if ([self.currentSelectedItem isKindOfClass:[AnimationEditMenuItem class]]) {
        AnimationEditMenuItem *item = (AnimationEditMenuItem *)self.currentSelectedItem;
        item.animationTitle = animationName;
        item.animationOrder = animationOrder;
    }
}
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    [bezierPath moveToPoint:CGPointMake(maxX * 0.5 + EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT - 1)];
    [bezierPath addLineToPoint:CGPointMake(maxX * 0.5, maxY)];
    [bezierPath addLineToPoint:CGPointMake(maxX * 0.5 - EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT - 1)];
    [bezierPath closePath];
    [[EditMenuItem normalStateColor] setFill];
    [bezierPath fill];
    
    for (NSNumber *separatorLocation in self.separatorLocations) {
        CGFloat location = [separatorLocation doubleValue];
        UIBezierPath *separator = [UIBezierPath bezierPathWithRect:CGRectMake(location, 0, SEPARATOR_WIDTH, self.itemHeight)];
        [[UIColor colorWithWhite:1 alpha:0.5] setFill];
        [separator fill];
    }
}

- (void) hide
{
    [super hide];
    [self removeFromSuperview];
}

@end
