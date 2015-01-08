//
//  ImageContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"
#import "ImageContentDTO.h"
@class ImageContainerView;

@protocol ImageContainerViewDelegate <ContentContainerViewDelegate>

- (void) handleTapOnImage:(ImageContainerView *) imageContainer;

@end

@interface ImageContainerView : GenericContainerView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<ImageContainerViewDelegate> delegate;

- (instancetype) initWithAttributes:(ImageContentDTO *)attributes delegate:(id<ContentContainerViewDelegate>)delegate;

@end
