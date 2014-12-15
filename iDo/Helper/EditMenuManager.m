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
#import "AnimationModeManager.h"

static EditMenuManager *sharedInstance;
#define REPLACE_ITEM_INDEX 2
#define PASTE_ITEM_INDEX 0

@interface EditMenuManager ()
@property (nonatomic, strong) NSArray *basicOperationsForContentView;
@property (nonatomic, strong) NSArray *basicOperationsForCanvas;
@property (nonatomic, strong) NSArray *animationOperationsForContentView;
@property (nonatomic, strong) NSArray *animationOperationsForCanvas;
@property (nonatomic) BOOL editMenuShown;
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
        _basicOperationsForContentView = [NSArray arrayWithObjects:@(EditMenuAvailableOperationCopy), @(EditMenuAvailableOperationCut), @(EditMenuAvailableOperationDelete), @(EditMenuAvailableOperationAnimate), nil];
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

- (NSArray *) animationOperationsForCanvas
{
    if (!_animationOperationsForCanvas) {
        _animationOperationsForCanvas = @[@(EditMenuAvailableOperationTransitionIn)];
    }
    return _animationOperationsForCanvas;
}

- (NSArray *) animationOperationsForContentView
{
    if (!_animationOperationsForContentView) {
        _animationOperationsForContentView = @[@(EditMenuAvailableOperationAnimateIn), @(EditMenuAvailableOperationAnimateOut)];
    }
    return _animationOperationsForContentView;
}

#pragma mark - Show/Hide
- (void) showEditMenuToView:(UIView *) view
{
    if (self.editMenuShown == YES) {
        [self hideEditMenu];
        return;
    }
    if ([view isKindOfClass:[GenericContainerView class]]) {
        [self showEditMenuToContentView:(GenericContainerView *)view];
    } else if ([view isKindOfClass:[CanvasView class]]) {
        [self showEditMenuToCanvas:(CanvasView *) view];
    }
}

- (NSArray *) availableOperationsForView:(UIView *) view
{
    if ([[AnimationModeManager sharedManager] isInAnimationMode]) {
        if ([view isKindOfClass:[GenericContainerView class]]) {
            return self.animationOperationsForContentView;
        } else {
            return self.animationOperationsForCanvas;
        }
    } else {
        NSData *existingData = [PasteboardHelper dataFromPasteboard];
        NSMutableArray *availableOperations;
        if ([view isKindOfClass:[GenericContainerView class]]) {
            availableOperations = [NSMutableArray arrayWithArray:self.basicOperationsForContentView];
            if (existingData) {
                [availableOperations insertObject:@(EditMenuAvailableOperationReplace) atIndex:REPLACE_ITEM_INDEX];
            }
            return availableOperations;
        } else {
            availableOperations = [NSMutableArray arrayWithArray:self.basicOperationsForCanvas];
            if (existingData) {
                [availableOperations insertObject:@(EditMenuAvailableOperationPaste) atIndex:PASTE_ITEM_INDEX];
            }
        }
        return availableOperations;
    }
}

- (void) showEditMenuToContentView:(GenericContainerView *) content
{
    self.editMenuShown = YES;
    NSArray *availableOperations = [self availableOperationsForView:content];
    [self.editMenu showWithAvailableOperations:availableOperations toContent:content];
    CGPoint center = CGPointMake(content.center.x, content.frame.origin.y - self.editMenu.frame.size.height / 2);
    center = [self.containerView convertPoint:center fromView:content.superview];
    self.editMenu.center = center;
}

- (void) showEditMenuToCanvas:(CanvasView *) canvas
{
    self.editMenuShown = YES;
    NSArray *availableOperations = [self availableOperationsForView:canvas];
    [self.editMenu showWithAvailableOperations:availableOperations toCanvas:canvas];
    CGPoint origin;
    CGPoint canvasOrigin = [self.containerView convertPoint:canvas.frame.origin fromView:canvas.superview];
    CGPoint canvasCenter = [self.containerView convertPoint:canvas.center fromView:canvas.superview];
    origin.y = canvasOrigin.y - self.editMenu.frame.size.height;
    origin.x = canvasCenter.x - self.editMenu.frame.size.width * [DrawingConstants counterGoldenRatio];
    self.editMenu.frame = CGRectMake(origin.x, origin.y, self.editMenu.frame.size.width, self.editMenu.frame.size.height);
}

- (void) hideEditMenu
{
    self.editMenuShown = NO;
    self.editMenu.hidden = YES;
}

- (void) updateEditMenu
{
    [self.editMenu update];
}

- (void) updateEditMenuWithAnimationName:(NSString *)animationName
{
    [self.editMenu updateEditAnimationItemWithAnimationName:animationName];
}
@end
