//
//  ControlPointManager.m
//  iDo
//
//  Created by Huang Hongsen on 10/19/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ControlPointManager.h"
#import "GenericContainerView.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "KeyConstants.h"

@interface ControlPointManager ()<BorderControlPointViewDelegate>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) BorderControlPointView *topLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *topMiddleControlPoint;
@property (nonatomic, strong) BorderControlPointView *topRightControlPoint;
@property (nonatomic, strong) BorderControlPointView *middleLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *middleRightControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomMiddleControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomRightControlPoint;
@property (nonatomic) CGRect previousFrame;
@property (nonatomic) CGRect originalFrame;
@end

static ControlPointManager *sharedInstance;

@implementation ControlPointManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        _topLeftControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationTopLeft delegate:self];
        _topMiddleControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationTopMiddle delegate:self];
        _topRightControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationTopRight delegate:self];
        _middleLeftControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationMiddleLeft delegate:self];
        _middleRightControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationMiddleRight delegate:self];
        _bottomLeftControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationBottomLeft delegate:self];
        _bottomMiddleControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationBottomMiddle delegate:self];
        _bottomRightControlPoint = [[BorderControlPointView alloc] initWithControlPointLocation:ControlPointLocationBottomRight delegate:self];

    }
    return self;
}

+ (ControlPointManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[ControlPointManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Public APIs
- (void) addAndLayoutControlPointsInView:(UIView *)view
{
    if (self.container != view) {
        self.container = view;
        [self addControlPoints];
    }
    [self layoutControlPoints];
}

- (void) removeAllControlPointsFromView:(UIView *)view
{
    if (self.container == view) {
        [self.topLeftControlPoint removeFromSuperview];
        [self.topMiddleControlPoint removeFromSuperview];
        [self.topRightControlPoint removeFromSuperview];
        [self.middleLeftControlPoint removeFromSuperview];
        [self.middleRightControlPoint removeFromSuperview];
        [self.bottomLeftControlPoint removeFromSuperview];
        [self.bottomMiddleControlPoint removeFromSuperview];
        [self.bottomRightControlPoint removeFromSuperview];
        self.container = nil;
    }
}

#pragma mark - BorderControlPointViewDelegate
- (UIView *) containerView
{
    return self.container;
}


- (void) controlPoint:(BorderControlPointView *)controlPoint
 didMoveByTranslation:(CGPoint)translation
           atPosition:(CGPoint)position
{
    if (!CGAffineTransformIsIdentity(self.container.transform)) {
        return;
    }
    switch (controlPoint.location) {
        case ControlPointLocationBottomLeft:
            [self handleBottomLeftControlPointTranslation:translation];
            break;
        case ControlPointLocationBottomMiddle:
            [self handleBottomMiddleControlPointTranslation:translation];
            break;
        case ControlPointLocationBottomRight:
            [self handleBottomRightControlPointTranslation:translation];
            break;
        case ControlPointLocationMiddleLeft:
            [self handleMiddleLeftControlPointTranslation:translation];
            break;
        case ControlPointLocationMiddleRight:
            [self handleMiddleRightControlPointTranslation:translation];
            break;
        case ControlPointLocationTopLeft:
            [self handleTopLeftControlPointTranslation:translation];
            break;
        case ControlPointLocationTopMiddle:
            [self handleTopMiddleControlPointTranslation:translation];
            break;
        case ControlPointLocationTopRight:
            [self handleTopRightControlPointTranslation:translation];
            break;
            
        default:
            break;
    }
}

- (void) controlPointDidStartMoving:(BorderControlPointView *)controlPoint
{
    self.originalFrame = self.containerView.frame;
}

- (void) controlPointDidFinishMoving:(BorderControlPointView *)controlPoint
{
    SimpleOperation *frameOperation = [[SimpleOperation alloc] initWithTargets:@[self.container] key:[KeyConstants frameKey] fromValue:[NSValue valueWithCGRect:self.originalFrame]];
    frameOperation.toValue = [NSValue valueWithCGRect:self.container.frame];
    [[UndoManager sharedManager] pushOperation:frameOperation];
}

#pragma mark - Control points moved handlers
- (void) handleBottomLeftControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin.x = self.container.frame.origin.x + translation.x;
    frame.origin.y = self.container.frame.origin.y;
    frame.size.width = self.container.frame.size.width - translation.x;
    frame.size.height = self.container.frame.size.height + translation.y;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleBottomMiddleControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin = self.container.frame.origin;
    frame.size.height = self.container.frame.size.height + translation.y;
    frame.size.width = self.container.frame.size.width;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleBottomRightControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin = self.container.frame.origin;
    frame.size.width = self.container.frame.size.width + translation.x;
    frame.size.height = self.container.frame.size.height + translation.y;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleMiddleLeftControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin.x = self.container.frame.origin.x + translation.x;
    frame.origin.y = self.container.frame.origin.y;
    frame.size.width = self.container.frame.size.width - translation.x;
    frame.size.height = self.container.frame.size.height;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleMiddleRightControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin = self.container.frame.origin;
    frame.size.width = self.container.frame.size.width + translation.x;
    frame.size.height = self.container.frame.size.height;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleTopLeftControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin.x = self.container.frame.origin.x + translation.x;
    frame.origin.y = self.container.frame.origin.y + translation.y;
    frame.size.width = self.container.frame.size.width - translation.x;
    frame.size.height = self.container.frame.size.height - translation.y;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleTopMiddleControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin.x = self.container.frame.origin.x;
    frame.origin.y = self.container.frame.origin.y + translation.y;
    frame.size.height = self.container.frame.size.height - translation.y;
    frame.size.width = self.container.frame.size.width;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

- (void) handleTopRightControlPointTranslation:(CGPoint) translation
{
    CGRect frame;
    frame.origin.x = self.container.frame.origin.x;
    frame.origin.y = self.container.frame.origin.y + translation.y;
    frame.size.width = self.container.frame.size.width + translation.x;
    frame.size.height = self.container.frame.size.height - translation.y;
    [self updatePreviousFrameAndSuperViewFrameIfNecessary:frame];
}

#pragma mark - Private Helpers
- (CGFloat) centerXForMiddleControlPoints
{
    return CGRectGetMidX(self.container.bounds);
}

- (CGFloat) centerXForRightControlPoints
{
    return CGRectGetMaxX([self borderRectFromContainerViewBounds:self.container.bounds]);
}

- (CGFloat) centerYForTopControlPoints
{
    return CGRectGetMinY([self borderRectFromContainerViewBounds:self.container.bounds]);
}

- (CGFloat) centerYForMiddleControlPoints
{
    return CGRectGetMidY([self borderRectFromContainerViewBounds:self.container.bounds]);
}

- (CGFloat) centerYForBottomControlPoints
{
    return CGRectGetMaxY([self borderRectFromContainerViewBounds:self.container.bounds]);
}

- (CGRect) borderRectFromContainerViewBounds:(CGRect) containerViewBounds
{
    CGRect result;
    result.origin.x = CONTROL_POINT_SIZE_HALF;
    result.origin.y = CONTROL_POINT_SIZE_HALF;
    result.size.width = containerViewBounds.size.width - 2 * CONTROL_POINT_SIZE_HALF;
    result.size.height = containerViewBounds.size.height - 2 * CONTROL_POINT_SIZE_HALF;
    return result;
}

- (void) addControlPoints
{
    [self.container addSubview:self.topLeftControlPoint];
    [self.container addSubview:self.topMiddleControlPoint];
    [self.container addSubview:self.topRightControlPoint];
    [self.container addSubview:self.middleLeftControlPoint];
    [self.container addSubview:self.middleRightControlPoint];
    [self.container addSubview:self.bottomLeftControlPoint];
    [self.container addSubview:self.bottomMiddleControlPoint];
    [self.container addSubview:self.bottomRightControlPoint];
}

- (void) disableControlPoints
{
    self.topLeftControlPoint.userInteractionEnabled = NO;
    self.topMiddleControlPoint.userInteractionEnabled = NO;
    self.topRightControlPoint.userInteractionEnabled = NO;
    self.middleLeftControlPoint.userInteractionEnabled = NO;
    self.middleRightControlPoint.userInteractionEnabled = NO;
    self.bottomLeftControlPoint.userInteractionEnabled = NO;
    self.bottomRightControlPoint.userInteractionEnabled = NO;
    self.bottomMiddleControlPoint.userInteractionEnabled = NO;
}

- (void) enableControlPoints
{
    self.topLeftControlPoint.userInteractionEnabled = YES;
    self.topMiddleControlPoint.userInteractionEnabled = YES;
    self.topRightControlPoint.userInteractionEnabled = YES;
    self.middleLeftControlPoint.userInteractionEnabled = YES;
    self.middleRightControlPoint.userInteractionEnabled = YES;
    self.bottomLeftControlPoint.userInteractionEnabled = YES;
    self.bottomRightControlPoint.userInteractionEnabled = YES;
    self.bottomMiddleControlPoint.userInteractionEnabled = YES;
}

- (void) layoutControlPoints
{
    self.topLeftControlPoint.center = CGPointMake(CONTROL_POINT_SIZE_HALF, [self centerYForTopControlPoints]);
    self.topMiddleControlPoint.center = CGPointMake([self centerXForMiddleControlPoints], [self centerYForTopControlPoints]);
    self.topRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForTopControlPoints]);
    self.middleLeftControlPoint.center = CGPointMake(CONTROL_POINT_SIZE_HALF, [self centerYForMiddleControlPoints]);
    self.middleRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForMiddleControlPoints]);
    self.bottomLeftControlPoint.center = CGPointMake(CONTROL_POINT_SIZE_HALF, [self centerYForBottomControlPoints]);
    self.bottomMiddleControlPoint.center = CGPointMake([self centerXForMiddleControlPoints], [self centerYForBottomControlPoints]);
    self.bottomRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForBottomControlPoints]);
}

- (CGPoint) pointBytranslation:(CGPoint)translation
             fromOriginalPoint:(CGPoint) originalPoint
{
    CGPoint result;
    result.x = originalPoint.x + translation.x;
    result.y = originalPoint.y + translation.y;
    return result;
}

- (BOOL) shouldChangeFrame:(CGRect) frame
{
    GenericContainerView *container = (GenericContainerView *) self.container;
    if (frame.size.width < [container minSize].width || frame.size.height < [container minSize].height) {
        return  NO;
    }
    return YES;
}

- (void) updatePreviousFrameAndSuperViewFrameIfNecessary:(CGRect) frame
{
    self.previousFrame = frame;
    if ([self shouldChangeFrame:frame]) {
        self.container.frame = frame;
    }
}

- (CGPoint) contentViewCenterInSuperView
{
    CGPoint center;
    CGRect contentViewFrame = [self borderRectFromContainerViewBounds:self.container.bounds];
    center.x = CGRectGetMidX(contentViewFrame);
    center.y = CGRectGetMidY(contentViewFrame);
    CGPoint result = [self.container convertPoint:center toView:self.container.superview];
    return result;
}

@end
