//
//  EditMenuManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuManager.h"
#import "GenericContainerView.h"
#import "CanvasView.h"
#import "PasteboardHelper.h"
#import "DrawingConstants.h"

static EditMenuManager *sharedInstance;
#define REPLACE_ITEM_INDEX 2
#define PASTE_ITEM_INDEX 0

@interface EditMenuManager ()
@property (nonatomic, strong) NSArray *basicOperationsForContentView;
@property (nonatomic, strong) NSArray *basicOperationsForCanvas;
@end

@implementation EditMenuManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (EditMenuManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[EditMenuManager alloc] initInternal];
        sharedInstance.editMenu = [[ContentEditMenuView alloc] initWithFrame:CGRectZero];
    }
    return sharedInstance;
}

#pragma mark - Lazy Instantiations
- (NSArray *) basicOperationsForContentView
{
    if (!_basicOperationsForContentView) {
        _basicOperationsForContentView = [NSArray arrayWithObjects:@(EditMenuAvailableOperationCopy), @(EditMenuAvailableOperationCut), @(EditMenuAvailableOperationEdit), @(EditMenuAvailableOperationDelete), @(EditMenuAvailableOperationAnimate), nil];
    }
    return _basicOperationsForContentView;
}

- (NSArray *) basicOperationsForCanvas
{
    if (!_basicOperationsForCanvas) {
        _basicOperationsForCanvas = [NSArray arrayWithObjects:@(EditMenuAvailableOperationTransition), nil];
    }
    return _basicOperationsForCanvas;
}

#pragma mark - Show/Hide
- (void) showEditMenuToView:(UIView *) view
{
    if ([view isKindOfClass:[GenericContainerView class]]) {
        [self showEditMenuToContentView:(GenericContainerView *)view];
    } else if ([view isKindOfClass:[CanvasView class]]) {
        [self showEditMenuToCanvas:(CanvasView *) view];
    }
}

- (void) showEditMenuToContentView:(GenericContainerView *) content
{
    NSMutableArray *availableOperations = [NSMutableArray arrayWithArray:self.basicOperationsForContentView];
    NSData *existingData = [PasteboardHelper dataFromPasteboard];
    if (existingData) {
        [availableOperations insertObject:@(EditMenuAvailableOperationReplace) atIndex:REPLACE_ITEM_INDEX];
    }
    [self.editMenu showWithAvailableOperations:availableOperations toContent:content];
    CGPoint origin;
    origin.y = content.frame.origin.y - self.editMenu.frame.size.height;
    origin.x = content.center.x - self.editMenu.frame.size.width * [DrawingConstants counterGoldenRatio];
    origin = [self.containerView convertPoint:origin fromView:content.superview];
    self.editMenu.frame = CGRectMake(origin.x, origin.y, self.editMenu.frame.size.width, self.editMenu.frame.size.height);
}

- (void) showEditMenuToCanvas:(CanvasView *) canvas
{
    NSMutableArray *availableOperations = [NSMutableArray arrayWithArray:self.basicOperationsForCanvas];
    NSData *existingData = [PasteboardHelper dataFromPasteboard];
    if (existingData) {
        [availableOperations insertObject:@(EditMenuAvailableOperationPaste) atIndex:PASTE_ITEM_INDEX];
    }
    [self.editMenu showWithAvailableOperations:availableOperations toCanvas:canvas];
    CGPoint origin;
    origin.y = canvas.frame.origin.y - self.editMenu.frame.size.height - 15;
    origin.x = canvas.center.x - self.editMenu.frame.size.width * [DrawingConstants counterGoldenRatio];
    origin = [self.containerView convertPoint:origin fromView:canvas];
    self.editMenu.frame = CGRectMake(origin.x, origin.y, self.editMenu.frame.size.width, self.editMenu.frame.size.height);
}

- (void) hideEditMenu
{
    self.editMenu.hidden = YES;
}

- (void) updateEditMenu
{
    [self.editMenu update];
}
@end
