//
//  AnimationParameterSlider.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnimationParameterSlider;
@protocol AnimationParameterSliderDelegate <NSObject>

- (void) slider:(AnimationParameterSlider *) slider didChangeValue:(CGFloat) value;

@end

@interface AnimationParameterSlider : UISlider

@property (nonatomic, weak) id<AnimationParameterSliderDelegate> delegate;

@end
