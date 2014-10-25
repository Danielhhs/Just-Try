//
//  SliderWithTooltip.h
//  iDo
//
//  Created by Huang Hongsen on 10/24/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderWithTooltip;

@protocol SliderWithToolTipDelegate
- (void) touchDidEndInSlider:(SliderWithTooltip *) slider;
@end

@interface SliderWithTooltip : UISlider

@property (nonatomic, weak) id<SliderWithToolTipDelegate> delegate;

@end
