//
//  ContentEditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ContentEditMenuView.h"
#import "EditMenuItem.h"
#import "GenericContainerViewHelper.h"
#import "EditMenuHelper.h"
#import "PasteboardHelper.h"
#import "KeyConstants.h"
#import "AnimationModeManager.h"

#define EDIT_MENU_ARROW_HEIGHT 10
#define EDIT_MENU_ARROW_WIDTH_HALF 10
#define EDIT_MENU_CORNER_RADIUS 10
#define SEPARATOR_TOP_BOTTOM_MARGIN 5
#define REPLACE_ITEM_INDEX 2

@interface ContentEditMenuView ()
@property (nonatomic, strong) EditMenuItem *duplicateButton;
@property (nonatomic, strong) EditMenuItem *cutButton;
@property (nonatomic, strong) EditMenuItem *deleteButton;
@property (nonatomic, strong) EditMenuItem *replaceButton;
@property (nonatomic, strong) EditMenuItem *animateButton;
@property (nonatomic, strong) NSMutableArray *operations;
@end

@implementation ContentEditMenuView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _duplicateButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants duplicateText] editMenu:self action:@selector(handleCopy)];
        _cutButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants cutText] editMenu:self action:@selector(handleCut)];
        _deleteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants deleteText] editMenu:self action:@selector(handleDelete)];
        _replaceButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants replaceText] editMenu:self action:@selector(handleReplace)];
        _animateButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants animateText] editMenu:self action:@selector(handleAnimate)];
        self.backgroundColor = [UIColor clearColor];
        self.itemHeight = EDIT_ITEM_HEIGTH;
        self.hidden = YES;
    }
    return self;
}

- (NSMutableArray *) operations
{
    if (!_operations) {
        _operations = [NSMutableArray arrayWithObjects:self.duplicateButton, self.cutButton, self.deleteButton, self.animateButton, nil];
        self.availableOperations = _operations;
    }
    return _operations;
}

- (void) updateOperations
{
    if ([PasteboardHelper dataFromPasteboard] && ![self.operations containsObject:self.replaceButton]) {
        [self.operations insertObject:self.replaceButton atIndex:REPLACE_ITEM_INDEX];
    } else if (![PasteboardHelper dataFromPasteboard] && [self.operations containsObject:self.replaceButton]) {
        [self.operations removeObject:self.replaceButton];
    }
}

- (void) handleCopy
{
    BOOL editMenuNeedRefresh = ([PasteboardHelper dataFromPasteboard] == nil);
    [PasteboardHelper copyData:[EditMenuHelper encodeGenericContent:self.triggeredContent]];
    [self.duplicateButton restoreNormalState];
    if (editMenuNeedRefresh) {
        [self.delegate refreshEditMenuToView:self.triggeredContent];
    }
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

- (void) showToContent:(GenericContainerView *)content animated:(BOOL) animated
{
    self.triggeredContent = content;
    self.trigger = content;
    [self updateOperations];
    for (NSInteger i = 0; i < [self.operations count]; i++) {
        EditMenuItem *item = self.operations[i];
        item.type = [self itemTypeForButtonItem:item index:i totalItems:[self.operations count]];
        [self addSubview:item];
    }
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    if (animated) {
        self.alpha = 0;
        [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
            self.alpha = 1;
        }];
    }
    [self setNeedsDisplay];
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
        case EditMenuAvailableOperationDelete:
            return self.deleteButton;
        case EditMenuAvailableOperationReplace:
            return self.replaceButton;
        default:
            return nil;
    }
}

- (void) hide
{
    [self.availableOperations removeObject:self.replaceButton];
    [self.replaceButton removeFromSuperview];
    self.triggeredContent = nil;
    [self removeFromSuperview];
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
@end
