//
//  SliderWithTooltip.m
//  iDo
//
//  Created by Huang Hongsen on 10/24/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SliderWithTooltip.h"

#define THUMB_RADIUS 5

@implementation SliderWithTooltip

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.delegate touchDidEndInSlider:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.delegate touchDidEndInSlider:self];
}

@end
