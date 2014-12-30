//
//  AnimationIndicatorView.h
//  iDo
//
//  Created by Huang Hongsen on 12/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INDICATOR_EDGE_LENGTH 30
@interface AnimationIndicatorView : UIView
@property (nonatomic) BOOL hasAnimation;
@property (nonatomic) BOOL selected;

- (void) drawIndicatorShape;
- (UIColor *) fillColor;
- (void) drawPlus;
- (UIColor *) textColor;
@end
