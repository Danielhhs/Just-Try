//
//  ShadowHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_SHADOW_DEPTH 0.5

@interface ShadowHelper : NSObject
+ (UIBezierPath *) shadowPathWithShadowDepthRatio:(CGFloat) shadowDepthRatio
                               originalViewHeight:(CGFloat) height
                         originalViewContentFrame:(CGRect) originalContentFrame;

@end
