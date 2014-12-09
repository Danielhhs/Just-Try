//
//  ToolbarManager.m
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ToolbarManager.h"
#import "DrawingConstants.h"
@interface ToolbarManager()
@property (nonatomic, strong) SlideEditingToolbarViewController *slideEditingToolbar;
@property (nonatomic, strong) AnimationToolbarViewController *animationToolbar;
@end

static ToolbarManager *sharedInstance;

@implementation ToolbarManager
#pragma mark - Singleton
+ (ToolbarManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[ToolbarManager alloc] initInternal];
    }
    return sharedInstance;
}

- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.slideEditingToolbar = [[UIStoryboard storyboardWithName:@"UtilViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"SlideEditingToolbarViewController"];
        self.animationToolbar = [[UIStoryboard storyboardWithName:@"UtilViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"AnimationToolbarViewController"];
    }
    return self;
}

#pragma mark - Slide Editing Toolbar
- (void) showEditingToolBarToViewController:(UIViewController *)viewController
{
    if ([viewController conformsToProtocol:@protocol(SlideEditingToolbarDelegate) ] ) {
        id<SlideEditingToolbarDelegate> toolBarDelegate = (id<SlideEditingToolbarDelegate>)viewController;
        self.slideEditingToolbar.delegate = toolBarDelegate;
    }
    [viewController addChildViewController:self.slideEditingToolbar];
    self.slideEditingToolbar.view.frame = CGRectMake(0, 0, self.slideEditingToolbar.view.frame.size.width, [DrawingConstants topBarHeight]);
    [viewController.view addSubview:self.slideEditingToolbar.view];
    [viewController.view insertSubview:self.slideEditingToolbar.view belowSubview:self.animationToolbar.view];
    [self.slideEditingToolbar didMoveToParentViewController:viewController];
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.animationToolbar.view.frame = CGRectMake(0, -1 * ([DrawingConstants topBarHeight]), self.animationToolbar.view.frame.size.width, [DrawingConstants topBarHeight]);
    } completion:^(BOOL finished) {
        [self.animationToolbar willMoveToParentViewController:nil];
        [self.animationToolbar.view removeFromSuperview];
        [self.animationToolbar removeFromParentViewController];
        [viewController.view bringSubviewToFront:self.slideEditingToolbar.view];
    }];
}

- (void) hideEditingToolBarFromViewController:(UIViewController *)viewController
{
    [self.slideEditingToolbar willMoveToParentViewController:nil];
    [self.slideEditingToolbar.view removeFromSuperview];
    [self.slideEditingToolbar removeFromParentViewController];
}

#pragma mark - Animation Toolbar
- (void) showAnimationToolBarToViewController:(UIViewController *)viewController
{
    if ([viewController conformsToProtocol:@protocol(AnimationToolbarViewControllerDelegate) ] ) {
        id<AnimationToolbarViewControllerDelegate> toolBarDelegate = (id<AnimationToolbarViewControllerDelegate>)viewController;
        self.animationToolbar.delegate = toolBarDelegate;
    }
    [viewController addChildViewController:self.animationToolbar];
    self.animationToolbar.view.frame = CGRectMake(0, -1 * ([DrawingConstants topBarHeight]), self.animationToolbar.view.frame.size.width, [DrawingConstants topBarHeight]);
    [viewController.view addSubview:self.animationToolbar.view];
    [self.animationToolbar didMoveToParentViewController:viewController];
    [viewController.view bringSubviewToFront:self.animationToolbar.view];
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.animationToolbar.view.frame = CGRectMake(0, 0, self.animationToolbar.view.frame.size.width, [DrawingConstants topBarHeight]);
    } completion:^(BOOL finished) {
        [self hideEditingToolBarFromViewController:viewController];
    }];
}

- (void) hideAnimationToolBarFromViewController:(UIViewController *)viewController
{
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.animationToolbar.view.frame = CGRectMake(0, -1 * ([DrawingConstants topBarHeight]), self.animationToolbar.view.frame.size.width, [DrawingConstants topBarHeight]);
    } completion:^(BOOL finished) {
        [self.animationToolbar willMoveToParentViewController:nil];
        [self.animationToolbar.view removeFromSuperview];
        [self.animationToolbar removeFromParentViewController];
    }];
}

@end
