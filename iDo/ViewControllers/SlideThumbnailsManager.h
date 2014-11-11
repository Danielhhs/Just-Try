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

@interface SlideThumbnailsManager : NSObject

+ (SlideThumbnailsManager *) sharedManager;

- (void) showThumbnailsInViewController:(UIViewController *)controller;

- (void) hideThumnailsFromViewController:(UIViewController *)controller;

- (CGFloat) thumbnailViewControllerWidth;

- (void) setupThumbnailsWithProposalAttributes:(NSDictionary *) proposalAttributes;

- (void) selectSlideAtIndex:(NSInteger) index;

- (void) setSlideThumbnailControllerDelegate:(id<SlidesThumbnailViewControllerDelegate>) delegate;

@end
