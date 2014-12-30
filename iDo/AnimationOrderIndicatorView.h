//
//  AnimationOrderIndicatorView.h
//  iDo
//
//  Created by Huang Hongsen on 12/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
#import "AnimationIndicatorView.h"
@interface AnimationOrderIndicatorView : AnimationIndicatorView
+ (AnimationOrderIndicatorView *) animationOrderIndicatorForEvent:(AnimationEvent)event;

@property (nonatomic) NSInteger animatinOrder;
@property (nonatomic) AnimationEvent event;
@end
