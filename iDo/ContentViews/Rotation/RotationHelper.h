//
//  RotationHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RotationIndicatorView.h"

@interface RotationHelper : NSObject

+ (void) applyRotationIndicatorToView:(UIView *)view;
+ (void) hideRotationIndicator;
+ (void) updateRotationIndicator;

@end
