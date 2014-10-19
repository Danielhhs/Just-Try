//
//  ImageContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"

@interface ImageContainerView : GenericContainerView

@property (nonatomic, strong) UIImage *image;

- (instancetype) initWithImage:(UIImage *) image;

@end
