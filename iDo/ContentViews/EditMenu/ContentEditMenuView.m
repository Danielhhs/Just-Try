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

#define SEPARATOR_WIDTH 3
#define EDIT_MENU_ARROW_HEIGHT 10
#define EDIT_MENU_ARROW_WIDTH_HALF 10
#define EDIT_MENU_CORNER_RADIUS 10
#define EDIT_ITEM_HEIGTH 61.8
#define SEPARATOR_TOP_BOTTOM_MARGIN 5
#define PASTE_ITEM_INDEX 2

@interface ContentEditMenuView ()
@property (nonatomic, strong) NSMutableArray *availableOperations;
@property (nonatomic, strong) EditMenuItem *duplicateButton;
@property (nonatomic, strong) EditMenuItem *cutButton;
@property (nonatomic, strong) EditMenuItem *pasteButton;
@property (nonatomic, strong) EditMenuItem *editButton;
@property (nonatomic, strong) EditMenuItem *deleteButton;
@property (nonatomic, strong) NSMutableArray *separatorLocations;
@end

@implementation ContentEditMenuView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _duplicateButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants duplicateText] editMenu:self action:@selector(handleCopy)];
        _cutButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants cutText] editMenu:self action:@selector(handleCut)];
        _pasteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants pasteText] editMenu:self action:@selector(handlePaste)];
        _editButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants editText] editMenu:self action:@selector(handleEdit)];
        _deleteButton = [[EditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, EDIT_ITEM_HEIGTH) title:[TextConstants deleteText] editMenu:self action:@selector(handleDelete)];
        [self adjustButtonWidth:_duplicateButton];
        [self adjustButtonWidth:_cutButton];
        [self adjustButtonWidth:_pasteButton];
        [self adjustButtonWidth:_editButton];
        [self adjustButtonWidth:_deleteButton];
        [self addSubview:_duplicateButton];
        [self addSubview:_cutButton];
        [self addSubview:_editButton];
        [self addSubview:_deleteButton];
        
        self.availableOperations = [@[_duplicateButton, _cutButton, _editButton, _deleteButton] mutableCopy];
        self.separatorLocations = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void) adjustButtonWidth:(EditMenuItem *) button
{
    CGSize sizeThatFits = [button sizeThatFits:button.bounds.size];
    CGRect bounds = button.bounds;
    bounds.size.width = sizeThatFits.width + 40;
    button.bounds = bounds;
}

- (void) handleCopy
{
    NSLog(@"%@ copied", [self.triggeredContent attributes]);
    [PasteboardHelper copyData:[EditMenuHelper encodeGenericContent:self.triggeredContent]];
    self.duplicateButton.backgroundColor = [UIColor clearColor];
}

- (void) handlePaste
{
    NSData *data = [PasteboardHelper dataFromPasteboard];
    NSMutableDictionary *attributes = [EditMenuHelper decodeGenericContentFromData:data];
    GenericContainerView *pasteContent = [GenericContainerViewHelper contentViewFromAttributes:attributes delegate:self.triggeredContent.delegate];
    [self.delegate editMenu:self didPasteContent:pasteContent];
    self.pasteButton.backgroundColor = [UIColor clearColor];
}

- (void) handleCut
{
    [self handleCopy];
    [self.delegate editMenu:self didCutContent:self.triggeredContent];
    self.cutButton.backgroundColor = [UIColor clearColor];
}

- (void) handleEdit
{
    [self.delegate editMenu:self didEditContent:self.triggeredContent];
    self.editButton.backgroundColor = [UIColor clearColor];
}

- (void) handleDelete
{
    [self.delegate editMenu:self didDeleteContent:self.triggeredContent];
    self.deleteButton.backgroundColor = [UIColor clearColor];
}

- (void) show
{
    NSData *existingData = [PasteboardHelper dataFromPasteboard];
    if (existingData && ![self.availableOperations containsObject:self.pasteButton]) {
        [self addSubview:self.pasteButton];
        [self.availableOperations insertObject:self.pasteButton atIndex:PASTE_ITEM_INDEX];
    }
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    [self setNeedsDisplay];
}

- (CGRect) frameFromCurrentButtons
{
    CGRect frame;
    frame.size.width = 0;
    for (EditMenuItem *item in self.availableOperations) {
        CGFloat increment = item.bounds.size.width + SEPARATOR_WIDTH;
        frame.size.width += increment;
    }
    frame.size.height = self.editButton.bounds.size.height + EDIT_MENU_ARROW_HEIGHT;
    frame.origin.y = self.triggeredContent.frame.origin.y - frame.size.height;
    frame.origin.x = self.triggeredContent.center.x - frame.size.width * [DrawingConstants counterGoldenRatio];
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
    
    [bezierPath moveToPoint:CGPointMake(EDIT_MENU_CORNER_RADIUS, 0)];
    [bezierPath addLineToPoint:CGPointMake(maxX - EDIT_MENU_CORNER_RADIUS, 0)];
    [bezierPath addArcWithCenter:CGPointMake(maxX - EDIT_MENU_CORNER_RADIUS, EDIT_MENU_CORNER_RADIUS) radius:EDIT_MENU_CORNER_RADIUS startAngle:1.5 * M_PI endAngle:2 * M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(maxX, maxY - EDIT_MENU_CORNER_RADIUS - EDIT_MENU_ARROW_HEIGHT)];
    [bezierPath addArcWithCenter:CGPointMake(maxX - EDIT_MENU_CORNER_RADIUS, maxY - EDIT_MENU_CORNER_RADIUS - EDIT_MENU_ARROW_HEIGHT) radius:EDIT_MENU_CORNER_RADIUS startAngle:0 endAngle:M_PI / 2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio] + EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT)];
    [bezierPath addLineToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio], maxY)];
    [bezierPath addLineToPoint:CGPointMake(maxX * [DrawingConstants counterGoldenRatio] - EDIT_MENU_ARROW_WIDTH_HALF, maxY - EDIT_MENU_ARROW_HEIGHT)];
    [bezierPath addArcWithCenter:CGPointMake(EDIT_MENU_CORNER_RADIUS, maxY - EDIT_MENU_CORNER_RADIUS - EDIT_MENU_ARROW_HEIGHT) radius:EDIT_MENU_CORNER_RADIUS startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, EDIT_MENU_CORNER_RADIUS)];
    [bezierPath addArcWithCenter:CGPointMake(EDIT_MENU_CORNER_RADIUS, EDIT_MENU_CORNER_RADIUS) radius:EDIT_MENU_CORNER_RADIUS startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    
    [[UIColor colorWithWhite:0.1 alpha:0.9] setFill];
    [bezierPath fill];
    
    for (NSNumber *separatorLocation in self.separatorLocations) {
        CGFloat location = [separatorLocation doubleValue];
        UIBezierPath *separator = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(location, SEPARATOR_TOP_BOTTOM_MARGIN, SEPARATOR_WIDTH, EDIT_ITEM_HEIGTH - 2 * SEPARATOR_TOP_BOTTOM_MARGIN) cornerRadius:SEPARATOR_WIDTH / 2];
        [[UIColor colorWithWhite:1 alpha:0.5] setFill];
        [separator fill];
    }
}


@end
