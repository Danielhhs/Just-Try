//
//  AnimationOrderIndicatorView.h
//  iDo
//
//  Created by Huang Hongsen on 12/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
@interface AnimationOrderIndicatorView : UIView
+ (AnimationOrderIndicatorView *) animationOrderIndicatorForEvent:(AnimationEvent)event;

@property (nonatomic) BOOL hasAnimation;
@property (nonatomic) NSInteger animatinOrder;
@property (nonatomic) BOOL selected;
@property (nonatomic) AnimationEvent event;
@end
