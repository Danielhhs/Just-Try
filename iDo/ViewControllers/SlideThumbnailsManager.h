//
//  SlideThumbnailsManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SlidesThumbnailViewController.h"
#import "ProposalDTO.h"

@interface SlideThumbnailsManager : NSObject

+ (SlideThumbnailsManager *) sharedManager;

- (void) showThumbnailsInViewController:(UIViewController *)controller animated:(BOOL) animated;

- (void) hideThumnailsFromViewController:(UIViewController *)controller animated:(BOOL) animated;

- (CGFloat) thumbnailViewControllerWidth;

- (void) setupThumbnailsWithProposalAttributes:(ProposalDTO *) proposalAttributes;

- (void) selectSlideAtIndex:(NSInteger) index;

- (void) setSlideThumbnailControllerDelegate:(id<SlidesThumbnailViewControllerDelegate>) delegate;

- (void) updateSlideSnapshotForItemAtIndex:(NSInteger) index;

- (CGPoint) thumbnailLocationForCurrentSlide;
@end
