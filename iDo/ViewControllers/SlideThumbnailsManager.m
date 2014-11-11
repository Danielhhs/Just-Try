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
        if ([controller isKindOfClass:[SlidesContainerViewController class]]) {
            [((SlidesContainerViewController *) controller) adjustCanvasSizeAndPosition];
        }
    }];
}

- (void) hideThumnailsFromViewController:(UIViewController *)controller
{
    self.thumbnailIsDisplaying = NO;
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

- (void) selectSlideAtIndex:(NSInteger)index
{
    self.slidesThumbnailController.currentSelectedIndex = index;
}

- (void) setSlideThumbnailControllerDelegate:(id<SlidesThumbnailViewControllerDelegate>)delegate
{
    self.slidesThumbnailController.delegate = delegate;
}
@end
