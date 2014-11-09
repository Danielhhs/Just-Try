//
//  SlideThumbnailsManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlideThumbnailsManager.h"
#import "SlidesThumbnailCollectionViewController.h"
#import "DrawingConstants.h"
#import "SlidesEditingViewController.h"

@interface SlideThumbnailsManager ()
@property (nonatomic, strong) SlidesThumbnailCollectionViewController *slidesThumbnailController;
@property (nonatomic) BOOL thumbnailIsDisplaying;
@end

static SlideThumbnailsManager *sharedInstance;

@implementation SlideThumbnailsManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.slidesThumbnailController = [[SlidesThumbnailCollectionViewController alloc] initWithNibName:@"SlidesThumbnailCollectionViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}

+ (SlideThumbnailsManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[SlideThumbnailsManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Thumbnail Show & Hide
- (void) showThumbnailsInViewController:(UIViewController *)controller
{
    [controller addChildViewController:self.slidesThumbnailController];
    self.slidesThumbnailController.view.frame = [self thumbnailControllerFrame];
    self.slidesThumbnailController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -1 * [DrawingConstants slidesThumbnailWidth], 0);
    [controller.view addSubview:self.slidesThumbnailController.view];
    [self.slidesThumbnailController didMoveToParentViewController:controller];
    self.thumbnailIsDisplaying = YES;
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.slidesThumbnailController.view.transform = CGAffineTransformIdentity;
        if ([controller isKindOfClass:[SlidesEditingViewController class]]) {
            [((SlidesEditingViewController *) controller) adjustCanvasSizeAndPosition];
        }
    }];
}

- (void) hideThumnailsFromViewController:(UIViewController *)controller
{
    [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
        self.slidesThumbnailController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -1 * [DrawingConstants slidesThumbnailWidth], 0);
        if ([controller isKindOfClass:[SlidesEditingViewController class]]) {
            [((SlidesEditingViewController *) controller) adjustCanvasSizeAndPosition];
        }
    } completion:^(BOOL finished) {
        self.slidesThumbnailController.view.transform = CGAffineTransformIdentity;
        [self.slidesThumbnailController willMoveToParentViewController:nil];
        [self.slidesThumbnailController.view removeFromSuperview];
        [self.slidesThumbnailController removeFromParentViewController];
        self.thumbnailIsDisplaying = NO;
    }];
    
}

- (CGRect) thumbnailControllerFrame
{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = [DrawingConstants topBarHeight];
    frame.size.width = [DrawingConstants slidesThumbnailWidth];
    frame.size.height = [DrawingConstants slidesEditorContentHeight];
    return frame;
}

- (CGFloat) thumbnailViewControllerWidth
{
    if (self.thumbnailIsDisplaying) {
        return [DrawingConstants slidesThumbnailWidth];
    } else {
        return 0;
    }
}
@end
