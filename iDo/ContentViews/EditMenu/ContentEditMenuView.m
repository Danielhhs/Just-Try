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
#import "DrawingConstants.h"
#import "EditMenuHelper.h"
#import "PasteboardHelper.h"
#import "CanvasView.h"

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
@property (nonatomic, strong) NSMutableArray *separatorLocations;
@property (nonatomic, weak) UIView *trigger;
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
    [self.animateButton restoreNormalState];
}

- (void) handleTransition
{
    [self.transitionButton restoreNormalState];
}

- (void) showWithAvailableOperations:(NSArray *)availableOperations toContent:(GenericContainerView *)content
{
    self.triggeredContent = content;
    self.trigger = content;
    [self updateOperationButtonsFromAvailableOperations:availableOperations];
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    [self setNeedsDisplay];
}

- (void) showWithAvailableOperations:(NSArray *)availableOperations toCanvas:(CanvasView *)canvas
{
    self.triggeredCanvas = canvas;
    self.trigger = canvas;
    [self updateOperationButtonsFromAvailableOperations:availableOperations];
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    [self setNeedsDisplay];
}

- (void) updateOperationButtonsFromAvailableOperations:(NSArray *) availableOperations
{
    [self.availableOperations removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < [availableOperations count]; i++) {
        EditMenuItem *item = [self availableOperationForType:[availableOperations[i] integerValue]];
        item.type = [self itemTypeForItemAtIndex:i totalItems:[availableOperations count]];
        [self.availableOperations addObject:item];
        [self addSubview:item];
    }
}

- (EditMenuItemType) itemTypeForItemAtIndex:(NSInteger) index totalItems:(NSInteger) totalItems {
    if (totalItems == 1) {
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
    frame.size.height = self.duplicateButton.bounds.size.height + EDIT_MENU_ARROW_HEIGHT;
    frame.origin.y = self.trigger.frame.origin.y - frame.size.height;
    frame.origin.x = self.trigger.center.x - frame.size.width * [DrawingConstants counterGoldenRatio];
    return frame;
}

- (void) layoutButtons
{
    [self.separatorLocations removeAllObjects];
    CGFloat currentLocation = 0;
    for (EditMenuItem *item in self.availableOperations) {
        item.center = CGPointMake(currentLocation + CGRectGetMidX(item.bounds), item.center.y);
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
    
    [bezierPath moveToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio] + EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT - 1)];
    [bezierPath addLineToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio], maxY)];
    [bezierPath addLineToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio] - EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT - 1)];
    [bezierPath closePath];
    [[EditMenuItem normalStateColor] setFill];
    [bezierPath fill];
    
    for (NSNumber *separatorLocation in self.separatorLocations) {
        CGFloat location = [separatorLocation doubleValue];
        UIBezierPath *separator = [UIBezierPath bezierPathWithRect:CGRectMake(location, 0, SEPARATOR_WIDTH, EDIT_ITEM_HEIGTH)];
        [[UIColor colorWithWhite:1 alpha:0.5] setFill];
        [separator fill];
    }
}


@end
