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

static EditMenuManager *sharedInstance;
#define PASTE_ITEM_INDEX 2

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
        _basicOperationsForCanvas = [NSArray arrayWithObjects:@(EditMenuAvailableOperationAnimate), nil];
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
        [availableOperations insertObject:@(EditMenuAvailableOperationReplace) atIndex:PASTE_ITEM_INDEX];
    }
    [self.editMenu showWithAvailableOperations:availableOperations toContent:content];
}

- (void) showEditMenuToCanvas:(CanvasView *) canvas
{
    NSMutableArray *availableOperations = [NSMutableArray arrayWithArray:self.basicOperationsForCanvas];
    NSData *existingData = [PasteboardHelper dataFromPasteboard];
    if (existingData) {
        [availableOperations insertObject:@(EditMenuAvailableOperationPaste) atIndex:PASTE_ITEM_INDEX];
    }
    [self.editMenu showWithAvailableOperations:availableOperations toCanvas:canvas];
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
