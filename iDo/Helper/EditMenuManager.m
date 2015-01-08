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
#import "ContentEditMenuView.h"
#import "AnimationEditMenuView.h"
#import "TransitionEditMenuView.h"
#import "SlideEditMenuView.h"

static EditMenuManager *sharedInstance;
#define EDIT_MENU_VIEW_SPACE 12

@interface EditMenuManager ()
@property (nonatomic, strong) ContentEditMenuView *contentEditMenu;
@property (nonatomic, strong) SlideEditMenuView *slideEditMenu;
@property (nonatomic, strong) AnimationEditMenuView *animationEditMenu;
@property (nonatomic, strong) TransitionEditMenuView *transitionEditMenu;
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
        self.contentEditMenu = [[ContentEditMenuView alloc] initWithFrame:CGRectZero];
        self.slideEditMenu = [[SlideEditMenuView alloc] initWithFrame:CGRectZero];
        self.animationEditMenu = [[AnimationEditMenuView alloc] initWithFrame:CGRectZero];
        self.transitionEditMenu = [[TransitionEditMenuView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

+ (EditMenuManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[EditMenuManager alloc] initInternal];
    }
    return sharedInstance;
}

- (void) setDelegate:(id<EditMenuViewDelegate>)delegate
{
    self.contentEditMenu.delegate = delegate;
    self.slideEditMenu.delegate = delegate;
    self.animationEditMenu.delegate = delegate;
    self.transitionEditMenu.delegate = delegate;
}

#pragma mark - Show/Hide
- (void) updateEditMenuWithView:(UIView *)view {
    [self showEditMenuToContentView:(GenericContainerView *)view animated:NO];
}

- (void) showEditMenuToView:(UIView *) view
{
    if (self.editMenuShown == YES && view == self.editMenu.trigger) {
        [self hideEditMenu];
        return;
    }
    [self refreshEditMenuViewToView:view];
}

- (void) refreshEditMenuViewToView:(UIView *) view
{
    if ([view isKindOfClass:[GenericContainerView class]]) {
        [self showEditMenuToContentView:(GenericContainerView *)view animated:YES];
    } else if ([view isKindOfClass:[CanvasView class]]) {
        [self showEditMenuToCanvas:(CanvasView *) view animated:YES];
    }
    [self.containerView addSubview:self.editMenu];
}

- (void) showEditMenuToContentView:(GenericContainerView *) content animated:(BOOL) animated
{
    [self hideEditMenu];
    self.editMenuShown = YES;
    if ([[AnimationModeManager sharedManager] isInAnimationMode] == NO) {
        self.editMenu = self.contentEditMenu;
        [self.contentEditMenu showToContent:content animated:animated];
    } else {
        self.editMenu = self.animationEditMenu;
        [self.animationEditMenu showToContent:content animated:animated];
    }
    [self.containerView addSubview:self.editMenu];
    CGPoint center = CGPointMake(content.center.x, content.frame.origin.y - self.editMenu.frame.size.height / 2 - EDIT_MENU_VIEW_SPACE);
    center = [self.containerView convertPoint:center fromView:content.superview];
    self.editMenu.center = center;
}

- (void) showEditMenuToCanvas:(CanvasView *) canvas animated:(BOOL) animated
{
    self.editMenuShown = YES;
    [self.editMenu hide];
    if ([[AnimationModeManager sharedManager] isInAnimationMode] == NO) {
        self.editMenu = self.slideEditMenu;
        [self.slideEditMenu showToCanvas:canvas animated:animated];
        CGPoint origin;
        CGPoint canvasOrigin = [self.containerView convertPoint:canvas.frame.origin fromView:canvas.superview];
        CGPoint canvasCenter = [self.containerView convertPoint:canvas.center fromView:canvas.superview];
        origin.y = canvasOrigin.y - self.editMenu.frame.size.height;
        origin.x = canvasCenter.x - self.editMenu.frame.size.width * [DrawingConstants counterGoldenRatio];
        self.editMenu.frame = CGRectMake(origin.x, origin.y, self.editMenu.frame.size.width, self.editMenu.frame.size.height);
    } else {
        self.editMenu = self.transitionEditMenu;
        [self.transitionEditMenu showToCanvas:canvas animated:animated];
        CGPoint origin = [self.transitionEditMenu.delegate thumbnailLocationForCurrentSlide];
        origin.y = origin.y - self.editMenu.frame.size.height / 2;
        self.editMenu.frame = CGRectMake(origin.x, origin.y, self.editMenu.frame.size.width, self.editMenu.frame.size.height);
    }
}

- (void) hideEditMenu
{
    self.editMenuShown = NO;
    [self.editMenu hide];
}

- (void) updateEditMenu
{
    [self.editMenu update];
}

- (void) updateEditMenuWithAnimationName:(NSString *)animationName animationOrder:(NSInteger)animationOrder
{
    [self.animationEditMenu updateEditAnimationItemWithAnimationName:animationName animationOrder:animationOrder];
}
@end
