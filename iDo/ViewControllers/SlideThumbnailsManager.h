//
//  SlideThumbnailsManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SlideThumbnailsManager : NSObject

+ (SlideThumbnailsManager *) sharedManager;

- (void) showThumbnailsInViewController:(UIViewController *)controller;

- (void) hideThumnailsFromViewController:(UIViewController *)controller;

- (CGFloat) thumbnailViewControllerWidth;

@end
