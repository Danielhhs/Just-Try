//
//  AnimationTypesGenerator.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
@interface AnimationTypesGenerator : NSObject
+ (AnimationTypesGenerator *) generator;
- (NSArray *) animationTypesForContentView:(UIView *) content type:(AnimationEvent) animationEvent;

@end
