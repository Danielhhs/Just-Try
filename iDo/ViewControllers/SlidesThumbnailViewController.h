//
//  SlidesThumbnailViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidesThumbnailViewController;
@protocol SlidesThumbnailViewControllerDelegate

- (void) slideDidAddAtIndex:(NSInteger)index fromSlidesThumbnailViewController:(SlidesThumbnailViewController *)thumbnailController;
- (void) slideThumbnailController:(SlidesThumbnailViewController *) thumbnailController
            didSelectSlideAtIndex:(NSInteger) index;
- (void) slideThumbnailController:(SlidesThumbnailViewController *) controller
             didSwtichCellAtIndex:(NSInteger) fromIndex
                          toIndex:(NSInteger) toIndex;
@end

@interface SlidesThumbnailViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *slides;
@property (nonatomic) NSInteger currentSelectedIndex;
@property (nonatomic, weak) id<SlidesThumbnailViewControllerDelegate> delegate;

- (void) reloadThumbnailForItemAtIndex:(NSInteger)index;
- (CGPoint) thumbnailLocationForCurrentSlide;
@end
