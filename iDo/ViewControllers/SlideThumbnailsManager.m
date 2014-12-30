//
//  SlideThumbnailsManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlideThumbnailsManager.h"
#import "DrawingConstants.h"
#import "SlidesContainerViewController.h"
#import "KeyConstants.h"

@interface SlideThumbnailsManager ()
@property (nonatomic, strong) SlidesThumbnailViewController *slidesThumbnailController;
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UtilViewControllers" bundle:[NSBundle mainBundle]];
        self.slidesThumbnailController = [storyboard instantiateViewControllerWithIdentifier:@"SlidesThumbnailViewController"];
        
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

- (void) setupThumbnailsWithProposalAttributes:(NSDictionary *)proposalAttributes
{
    self.slidesThumbnailController.slides = proposalAttributes[[KeyConstants proposalSlidesKey]];
}

#pragma mark - Thumbnail Show & Hide
- (void) showThumbnailsInViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (!self.thumbnailIsDisplaying) {
        [controller addChildViewController:self.slidesThumbnailController];
        self.slidesThumbnailController.view.frame = [self thumbnailControllerFrame];
        [controller.view addSubview:self.slidesThumbnailController.view];
        [self.slidesThumbnailController didMoveToParentViewController:controller];
        self.thumbnailIsDisplaying = YES;
        if (animated) {
            self.slidesThumbnailController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -1 * [DrawingConstants slidesThumbnailWidth], 0);
            [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
                self.slidesThumbnailController.view.transform = CGAffineTransformIdentity;
                if ([controller isKindOfClass:[SlidesContainerViewController class]]) {
                    [((SlidesContainerViewController *) controller) adjustCanvasSizeAndPosition];
                }
            }];
        }
    }
}

- (void) hideThumnailsFromViewController:(UIViewController *)controller animated:(BOOL)animated
{
    self.thumbnailIsDisplaying = NO;
    if (animated) {
        [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
            self.slidesThumbnailController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -1 * [DrawingConstants slidesThumbnailWidth], 0);
            if ([controller isKindOfClass:[SlidesContainerViewController class]]) {
                [((SlidesContainerViewController *) controller) adjustCanvasSizeAndPosition];
            }
        } completion:^(BOOL finished) {
            self.slidesThumbnailController.view.transform = CGAffineTransformIdentity;
            [self.slidesThumbnailController willMoveToParentViewController:nil];
            [self.slidesThumbnailController.view removeFromSuperview];
            [self.slidesThumbnailController removeFromParentViewController];
        }];
    } else {
        [self.slidesThumbnailController willMoveToParentViewController:nil];
        [self.slidesThumbnailController.view removeFromSuperview];
        [self.slidesThumbnailController removeFromParentViewController];
    }
    
}

- (void) updateSlideSnapshotForItemAtIndex:(NSInteger)index
{
    if (self.thumbnailIsDisplaying) {
        [self.slidesThumbnailController reloadThumbnailForItemAtIndex:index];
    }
}

- (CGRect) thumbnailControllerFrame
{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = [DrawingConstants topBarHeight] + 1;
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

- (void) selectSlideAtIndex:(NSInteger)index
{
    self.slidesThumbnailController.currentSelectedIndex = index;
}

- (void) setSlideThumbnailControllerDelegate:(id<SlidesThumbnailViewControllerDelegate>)delegate
{
    self.slidesThumbnailController.delegate = delegate;
}

- (CGPoint) thumbnailLocationForCurrentSlide
{
    return [self.slidesThumbnailController thumbnailLocationForCurrentSlide];
}
@end
