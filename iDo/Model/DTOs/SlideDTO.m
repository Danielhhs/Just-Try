//
//  SlideDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "SlideDTO.h"

#define DEFAULT_BACKGROUND_IMAGE @"Canvas.png"
@implementation SlideDTO

+ (SlideDTO *) defaultSlide
{
    SlideDTO *slide = [[SlideDTO alloc] init];
    slide.backgroundImage = DEFAULT_BACKGROUND_IMAGE;
    slide.thumbnail = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE];
    slide.currentAnimationIndex = 0;
    slide.contents = [NSMutableArray array];
    return slide;
}

- (void) mergeChangedPropertiesFromSlide:(SlideDTO *)slide
{
    self.backgroundImage = slide.backgroundImage;
    self.thumbnail = slide.thumbnail;
    self.currentAnimationIndex = slide.currentAnimationIndex;
    self.contents = slide.contents;
    self.index = slide.index;
}
@end
