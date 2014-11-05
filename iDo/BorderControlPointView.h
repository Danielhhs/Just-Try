//
//  BorderControlPointView.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CONTROL_POINT_SIZE_HALF 20.f
#define CONTROL_POINT_RADIUS 5.F
@class BorderControlPointView;
@protocol BorderControlPointViewDelegate <NSObject>

- (void) controlPointDidStartMoving:(BorderControlPointView *) controlPoint;

- (void) controlPointDidFinishMoving:(BorderControlPointView *) controlPoint;

- (void) controlPoint:(BorderControlPointView *) controlPoint
    didMoveByTranslation:(CGPoint) translation
           atPosition:(CGPoint) position;

- (UIView *) containerView;

@end

typedef NS_ENUM(NSUInteger, ControlPointLocation) {
    ControlPointLocationTopLeft = 0,
    ControlPointLocationTopMiddle = 1,
    ControlPointLocationTopRight = 2,
    ControlPointLocationMiddleLeft = 3,
    ControlPointLocationMiddleRight = 4,
    ControlPointLocationBottomLeft = 5,
    ControlPointLocationBottomMiddle = 6,
    ControlPointLocationBottomRight = 7,
    ControlPointLocationTranslation = 8,
};

@interface BorderControlPointView : UIView

@property (nonatomic) ControlPointLocation location;
@property (nonatomic, weak) id<BorderControlPointViewDelegate> delegate;

- (instancetype) initWithControlPointLocation:(ControlPointLocation) location
                                     delegate:(id<BorderControlPointViewDelegate>) delegate;

@end
