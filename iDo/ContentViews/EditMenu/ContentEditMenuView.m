//
//  ContentEditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ContentEditMenuView.h"
#import "EditMenuItem.h"
#import "TextConstants.h"
#import "GenericContainerViewHelper.h"
#import "EditMenuHelper.h"
#import "PasteboardHelper.h"
#import "CanvasView.h"
#import "AnimationEditMenuItem.h"
#import "AnimationModeManager.h"
#import "DrawingConstants.h"
#import "AnimationModeManager.h"
#import "KeyConstants.h"
#import "AnimationAttributesHelper.h"

#define SEPARATOR_WIDTH 1
#define EDIT_MENU_ARROW_HEIGHT 10
#define EDIT_MENU_ARROW_WIDTH_HALF 10
#define EDIT_MENU_CORNER_RADIUS 10
#define EDIT_ITEM_HEIGTH 35
#define SEPARATOR_TOP_BOTTOM_MARGIN 5

@interface ContentEditMenuView ()
@property (nonatomic, strong) NSMutableArray *availableOperations;
@property (nonatomic, strong) EditMenuItem *duplicateButton;
@property (nonatomic, strong) EditMenuItem *cutButton;
@property (nonatomic, strong) EditMenuItem *pasteButton;
@property (nonatomic, strong) EditMenuItem *deleteButton;
@property (nonatomic, strong) EditMenuItem *replaceButton;
@property (nonatomic, strong) EditMenuItem *animateButton;
@property (nonatomic, strong) EditMenuItem *transitionButton;
@property (nonatomic, strong) AnimationEditMenuItem *animateInButton;
@property (nonatomic, strong) AnimationEditMenuItem *animateOutButton;
@property (nonatomic, strong) EditMenuItem *transitionInButton;
@property (nonatomic, strong) NSMutableArray *separatorLocations;
@property (nonatomic, weak) UIView *trigger;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic, weak) EditMenuItem *currentSelectedItem;
@end

@implementation ContentEditMenuView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _duplicateButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants duplicateText] editMenu:self action:@selector(handleCopy)];
        _cutButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants cutText] editMenu:self action:@selector(handleCut)];
        _pasteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants pasteText] editMenu:self action:@selector(handlePaste)];
        _deleteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants deleteText] editMenu:self action:@selector(handleDelete)];
        _replaceButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants replaceText] editMenu:self action:@selector(handleReplace)];
        _animateButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants animateText] editMenu:self action:@selector(handleAnimate)];
        _transitionButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants transitionText] editMenu:self action:@selector(handleTransition)];
        _animateInButton = [[AnimationEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants noneText] subTitle:[TextConstants animateInText] editMenu:self action:@selector(handleAnimateIn) type:EditMenuItemTypeLeftMost hasAnimation:YES animationOrder:1 animationEvent:AnimationEventBuiltIn];
        _animateOutButton = [[AnimationEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants noneText] subTitle:[TextConstants animateOutText] editMenu:self action:@selector(handleAnimateOut) type:EditMenuItemTypeRightMost hasAnimation:NO animationOrder:0 animationEvent:AnimationEventBuiltOut];
        _transitionInButton = [[AnimationEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants noneText] subTitle:nil editMenu:self action:@selector(handleTransitionIn) type:EditMenuItemTypeLeftArrow hasAnimation:NO animationOrder:0 animationEvent:AnimationEventTransition];
        self.availableOperations = [NSMutableArray array];
        self.separatorLocations = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void) handleCopy
{
    [PasteboardHelper copyData:[EditMenuHelper encodeGenericContent:self.triggeredContent]];
    [self.duplicateButton restoreNormalState];
}

- (void) handlePaste
{
    NSData *data = [PasteboardHelper dataFromPasteboard];
    NSMutableDictionary *attributes = [EditMenuHelper decodeGenericContentFromData:data];
    GenericContainerView *pasteContent = [GenericContainerViewHelper contentViewFromAttributes:attributes delegate:self.triggeredContent.delegate];
    [self.delegate editMenu:self didPasteContent:pasteContent];
    [self.pasteButton restoreNormalState];
}

- (void) handleCut
{
    [self handleCopy];
    [self.delegate editMenu:self didCutContent:self.triggeredContent];
    [self.cutButton restoreNormalState];
}

- (void) handleDelete
{
    [self.delegate editMenu:self didDeleteContent:self.triggeredContent];
    [self.deleteButton restoreNormalState];
}

- (void) handleReplace
{
    [self.replaceButton restoreNormalState];
}

- (void) handleAnimate
{
    [[AnimationModeManager sharedManager] enterAnimationModeFromView:self.trigger];
    [self.animateButton restoreNormalState];
}

- (void) handleTransition
{
    [self.transitionButton restoreNormalState];
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

- (void) handleTransitionIn
{
    self.currentSelectedItem = self.transitionButton;
    [self.transitionInButton restoreNormalState];
}

- (void) showWithAvailableOperations:(NSArray *)availableOperations toContent:(GenericContainerView *)content
{
    if ([[AnimationModeManager sharedManager] isInAnimationMode]) {
        self.animateInButton.animationTitle = [AnimationAttributesHelper animationInTitleForContent:content];
        self.animateOutButton.animationTitle = [AnimationAttributesHelper animationOutTitleForContent:content];
        [self updateAnimationOrderIndicatorsForContent:content];
    }
    self.triggeredContent = content;
    self.trigger = content;
    [self updateOperationButtonsFromAvailableOperations:availableOperations];
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.alpha = 1;
    }];
    [self setNeedsDisplay];
}

- (void) updateAnimationOrderIndicatorsForContent:(GenericContainerView *) content
{
    NSInteger animationOrder = [AnimationAttributesHelper animationOrderForAttributes:[content attributes] event:AnimationEventBuiltIn];
    [self.animateInButton setAnimationOrder:animationOrder];
    animationOrder = [AnimationAttributesHelper animationOrderForAttributes:[content attributes] event:AnimationEventBuiltOut];
    [self.animateOutButton setAnimationOrder:animationOrder];
}

- (void) showWithAvailableOperations:(NSArray *)availableOperations toCanvas:(CanvasView *)canvas
{
    self.triggeredCanvas = canvas;
    self.trigger = canvas;
    [self updateOperationButtonsFromAvailableOperations:availableOperations];
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.alpha = 1;
    }];
    [self setNeedsDisplay];
}

- (void) updateOperationButtonsFromAvailableOperations:(NSArray *) availableOperations
{
    [self.availableOperations removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < [availableOperations count]; i++) {
        EditMenuItem *item = [self availableOperationForType:[availableOperations[i] integerValue]];
        item.type = [self itemTypeForButtonItem:item index:i totalItems:[availableOperations count]];
        [self.availableOperations addObject:item];
        [self addSubview:item];
        self.itemHeight = item.bounds.size.height;
    }
}

- (EditMenuItemType) itemTypeForButtonItem:(EditMenuItem *) item index:(NSInteger) index totalItems:(NSInteger) totalItems {
    if (item == self.transitionInButton) {
        return EditMenuItemTypeLeftArrow;
    } else if (totalItems == 1) {
        return EditMenuItemTypeOnly;
    } else if (index == 0) {
        return EditMenuItemTypeLeftMost;
    } else if (index == totalItems - 1) {
        return EditMenuItemTypeRightMost;
    } else {
        return EditMenuItemTypeCommon;
    }
}

- (EditMenuItem *) availableOperationForType:(EditMenuAvailableOperation) type
{
    switch (type) {
        case EditMenuAvailableOperationAnimate:
            return self.animateButton;
        case EditMenuAvailableOperationCopy:
            return self.duplicateButton;
        case EditMenuAvailableOperationCut:
            return self.cutButton;
        case EditMenuAvailableOperationPaste:
            return self.pasteButton;
        case EditMenuAvailableOperationDelete:
            return self.deleteButton;
        case EditMenuAvailableOperationReplace:
            return self.replaceButton;
        case EditMenuAvailableOperationTransition:
            return self.transitionButton;
        case EditMenuAvailableOperationAnimateIn:
            return self.animateInButton;
        case EditMenuAvailableOperationAnimateOut:
            return self.animateOutButton;
        case EditMenuAvailableOperationTransitionIn:
            return self.transitionInButton;
        default:
            return nil;
    }
}
- (CGRect) frameFromCurrentButtons
{
    CGRect frame;
    frame.size.width = 0;
    for (EditMenuItem *item in self.availableOperations) {
        CGFloat increment = item.bounds.size.width + SEPARATOR_WIDTH;
        frame.size.width += increment;
    }
    frame.size.height = self.itemHeight + EDIT_MENU_ARROW_HEIGHT;
    frame.origin.y = self.trigger.frame.origin.y - self.itemHeight;
    frame.origin.x = self.trigger.center.x - self.bounds.size.width / 2;
    return frame;
}

- (void) layoutButtons
{
    [self.separatorLocations removeAllObjects];
    CGFloat currentLocation = 0;
    for (EditMenuItem *item in self.availableOperations) {
        item.center = CGPointMake(currentLocation + CGRectGetMidX(item.bounds), CGRectGetMidY(item.bounds));
        currentLocation = currentLocation + CGRectGetMaxX(item.bounds) + SEPARATOR_WIDTH;
        [self.separatorLocations addObject:@(currentLocation - SEPARATOR_WIDTH)];
    }
    [self.separatorLocations removeLastObject];
}

- (void) hide
{
    self.hidden = YES;
    [self.availableOperations removeObject:self.pasteButton];
    [self.pasteButton removeFromSuperview];
    self.triggeredContent = nil;
}

- (void) update
{
    if (self.hidden == NO) {
        self.frame = [self frameFromCurrentButtons];
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

- (void) updateEditAnimationItemWithAnimationName:(NSString *)animationName animationOrder:(NSInteger) animationOrder
{
    if ([self.currentSelectedItem isKindOfClass:[AnimationEditMenuItem class]]) {
        AnimationEditMenuItem *item = (AnimationEditMenuItem *)self.currentSelectedItem;
        item.animationTitle = animationName;
        item.animationOrder = animationOrder;
    }
}
@end
