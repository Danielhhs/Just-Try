//
//  ControlPointManager.h
//  iDo
//
//  Created by Huang Hongsen on 10/19/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderControlPointView.h"

#define MIN_CONTENT_HEIGHT 50
#define MIN_CONTENT_WIDTH 50

@interface ControlPointManager : NSObject

+ (ControlPointManager *) sharedManager;

- (void) addAndLayoutControlPointsInView:(UIView *)view;
- (void) layoutControlPoints;
- (void) removeAllControlPointsFromView:(UIView *) view;
- (CGRect) borderRectFromContainerViewBounds:(CGRect) containerViewBounds;
- (void) disableControlPoints;
- (void) enableControlPoints;
@end
