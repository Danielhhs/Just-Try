//
//  SlideEditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlideEditMenuView.h"
#import "EditMenuItem.h"
#import "TextConstants.h"
#import "EditMenuHelper.h"
#import "GenericContainerViewHelper.h"
#import "PasteboardHelper.h"
#import "DrawingConstants.h"
#import "AnimationModeManager.h"

#define EDIT_MENU_ARROW_HEIGHT 10
#define EDIT_MENU_ARROW_WIDTH_HALF 10

@interface SlideEditMenuView()

@property (nonatomic, strong) EditMenuItem *transitionButton;
@property (nonatomic, strong) EditMenuItem *pasteButton;
@property (nonatomic, strong) NSMutableArray *operations;
@end

#define EDIT_ITEM_HEIGTH 35
#define PASTE_ITEM_INDEX 0

@implementation SlideEditMenuView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pasteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants pasteText] editMenu:self action:@selector(handlePaste)];
        _transitionButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants transitionText] editMenu:self action:@selector(handleTransition)];
        self.itemHeight = EDIT_ITEM_HEIGTH;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSMutableArray *) operations
{
    if (!_operations) {
        _operations = [NSMutableArray arrayWithObject:self.transitionButton];
        self.availableOperations = _operations;
    }
    return _operations;
}

- (void) updateOperations
{
    if ([PasteboardHelper dataFromPasteboard] && ![self.operations containsObject:self.pasteButton]) {
        [self.operations insertObject:self.pasteButton atIndex:PASTE_ITEM_INDEX];
    } else if (![PasteboardHelper dataFromPasteboard] && [self.operations containsObject:self.pasteButton]) {
        [self.operations removeObject:self.pasteButton];
    }
}

- (void) showToCanvas:(CanvasView *)canvas animated:(BOOL)animated
{
    self.triggeredCanvas = canvas;
    self.trigger = canvas;
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

- (void) handlePaste
{
    NSData *data = [PasteboardHelper dataFromPasteboard];
    GenericContentDTO *attributes = [EditMenuHelper decodeGenericContentFromData:data];
    id<ContentContainerViewDelegate> delegate = nil;
    if ([self.triggeredCanvas.delegate conformsToProtocol:@protocol(ContentContainerViewDelegate)]) {
        delegate = (id<ContentContainerViewDelegate>)self.triggeredCanvas.delegate;
    }
    GenericContainerView *pasteContent = [GenericContainerViewHelper contentViewFromAttributes:attributes delegate:delegate];
    [self.delegate editMenu:self didPasteContent:pasteContent];
    [self.pasteButton restoreNormalState];
}

- (void) handleTransition
{
    [[AnimationModeManager sharedManager] enterAnimationModeFromView:self.triggeredCanvas];;
    [self.transitionButton restoreNormalState];
}

- (EditMenuItem *) availableOperationForType:(EditMenuAvailableOperation) type
{
    switch (type) {
        case EditMenuAvailableOperationPaste:
            return self.pasteButton;
        case EditMenuAvailableOperationTransition:
            return self.transitionButton;
        default:
            return nil;
    }
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
    [super hide];
    [self.availableOperations removeObject:self.pasteButton];
    [self.pasteButton removeFromSuperview];
    self.triggeredCanvas = nil;
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
