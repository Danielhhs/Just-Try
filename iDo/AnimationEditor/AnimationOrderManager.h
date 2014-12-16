//
//  AnimationOrderManager.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericContainerView.h"
@interface AnimationOrderManager : NSObject

+ (AnimationOrderManager *) sharedManager;
- (void) applyAnimationOrderIndicatorToView:(UIView *) view;
- (void) updateAnimationOrderIndicatorToView:(UIView *) view;
- (void) hideAnimationOrderIndicator;
@end
