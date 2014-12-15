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

@protocol ControlPointManagerDelegate <NSObject>
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;
- (void) addSubview:(UIView *) view;
- (CGPoint) convertPoint:(CGPoint)point toView:(UIView *) view;
- (UIView *) superview;
- (void) controlPointDidStartMoving;
- (void) controlPointDidFinishMoving;
- (NSArray *) animationAttributes;
@end

@interface ControlPointManager : NSObject

+ (ControlPointManager *) sharedManager;

@property (nonatomic, weak) id<ControlPointManagerDelegate> delegate;

- (void) addAndLayoutControlPointsInView:(id<ControlPointManagerDelegate>)view;
- (void) layoutControlPoints;
- (void) removeAllControlPointsFromView:(id<ControlPointManagerDelegate>) view;
- (CGRect) borderRectFromContainerViewBounds:(CGRect) containerViewBounds;
- (void) enableControlPoints;
- (UIColor *) borderColor;
- (void) updateControlPointColor;
@end
