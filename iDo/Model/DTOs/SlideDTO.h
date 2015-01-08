//
//  SlideDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"

@interface SlideDTO : DataTransferObject
@property (nonatomic) NSInteger unique;
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger currentAnimationIndex;
@property (nonatomic) NSString *backgroundImage;
+ (SlideDTO *) defaultSlide;

- (void) mergeChangedPropertiesFromSlide:(SlideDTO *) slide;
@end
