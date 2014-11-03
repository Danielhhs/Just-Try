//
//  SliderWithTooltip.h
//  iDo
//
//  Created by Huang Hongsen on 10/24/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Operation.h"

@class SliderWithTooltip;

@protocol SliderWithToolTipDelegate
- (void) touchDidEndInSlider:(SliderWithTooltip *) slider;
@end

@interface SliderWithTooltip : UISlider

@property (nonatomic, weak) id<OperationTarget> target;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, weak) id<SliderWithToolTipDelegate> delegate;

- (SimpleOperation *) setValue:(float)value generateOperations:(BOOL) generateOperations;

@end
