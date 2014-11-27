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
#import "CompoundOperation.h"
#import "KeyConstants.h"
#import "TextContainerView.h"
#import "DrawingConstants.h"

@interface ControlPointManager ()<BorderControlPointViewDelegate>
@property (nonatomic, strong) BorderControlPointView *topLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *topMiddleControlPoint;
@property (nonatomic, strong) BorderControlPointView *topRightControlPoint;
@property (nonatomic, strong) BorderControlPointView *middleLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *middleRightControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomLeftControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomMiddleControlPoint;
@property (nonatomic, strong) BorderControlPointView *bottomRightControlPoint;
@property (nonatomic) CGRect previousFrame;
@property (nonatomic) CGRect originalBounds;
@property (nonatomic) CGPoint originalCenter;
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
- (void) addAndLayoutControlPointsInView:(id<ControlPointManagerDelegate>)view
{
    if (self.delegate != view) {
        self.delegate = view;
        [self addControlPoints];
    }
    [self layoutControlPoints];
}

- (void) removeAllControlPointsFromView:(id<ControlPointManagerDelegate>)view
{
    if (self.delegate == view) {
        [self.topLeftControlPoint removeFromSuperview];
        [self.topMiddleControlPoint removeFromSuperview];
        [self.topRightControlPoint removeFromSuperview];
        [self.middleLeftControlPoint removeFromSuperview];
        [self.middleRightControlPoint removeFromSuperview];
        [self.bottomLeftControlPoint removeFromSuperview];
        [self.bottomMiddleControlPoint removeFromSuperview];
        [self.bottomRightControlPoint removeFromSuperview];
        self.delegate = nil;
    }
}

#pragma mark - BorderControlPointViewDelegate
- (UIView *) containerView
{
    return (UIView *)self.delegate;
}
- (void) controlPoint:(BorderControlPointView *)controlPoint
 didMoveByTranslation:(CGPoint)translation
translationInSuperView:(CGPoint)translationInSuperView
{
    switch (controlPoint.location) {
        case ControlPointLocationBottomLeft:
            [self handleBottomLeftControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationBottomMiddle:
            [self handleBottomMiddleControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationBottomRight:
            [self handleBottomRightControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationMiddleLeft:
            [self handleMiddleLeftControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationMiddleRight:
            [self handleMiddleRightControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationTopLeft:
            [self handleTopLeftControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationTopMiddle:
            [self handleTopMiddleControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
        case ControlPointLocationTopRight:
            [self handleTopRightControlPointTranslation:translation translationInSuperView:translationInSuperView];
            break;
            
        default:
            break;
    }
}

- (void) controlPointDidStartMoving:(BorderControlPointView *)controlPoint
{
    self.originalBounds = self.containerView.bounds;
    self.originalCenter = self.containerView.center;
    [self.delegate controlPointDidStartMoving];
}

- (void) controlPointDidFinishMoving:(BorderControlPointView *)controlPoint
{
    SimpleOperation *boundsOperation = [[SimpleOperation alloc] initWithTargets:@[self.delegate] key:[KeyConstants boundsKey] fromValue:[NSValue valueWithCGRect:self.originalBounds]];
    boundsOperation.toValue = [NSValue valueWithCGRect:self.delegate.bounds];
    SimpleOperation *centerOperation = [[SimpleOperation alloc] initWithTargets:@[self.delegate] key:[KeyConstants centerKey] fromValue:[NSValue valueWithCGPoint:self.originalCenter]];
    centerOperation.toValue = [NSValue valueWithCGPoint:self.delegate.center];
    
    CompoundOperation *frameOperation = [[CompoundOperation alloc] initWithOperations:@[boundsOperation, centerOperation]];
    [[UndoManager sharedManager] pushOperation:frameOperation];
    [self.delegate controlPointDidFinishMoving];
}

#pragma mark - Control points moved handlers
- (void) handleBottomLeftControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width - translation.x;
    bounds.size.height = bounds.size.height + translation.y;
    
    center.x = center.x + translationInSuperView.x / 2;
    center.y = center.y + translationInSuperView.y / 2;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleBottomMiddleControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView

{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.height = bounds.size.height + translation.y;
    CGFloat rotation = [self viewRotateRadians];
    CGFloat centerMoveX = - translation.y * sin(rotation) / 2;
    CGFloat centerMoveY = translation.y * cos(rotation) / 2;
    center.x = center.x + centerMoveX;
    center.y = center.y + centerMoveY;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleBottomRightControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width + translation.x;
    bounds.size.height = bounds.size.height + translation.y;
    center.x = center.x + translationInSuperView.x / 2;
    center.y = center.y + translationInSuperView.y / 2;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleMiddleLeftControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width - translation.x;
    CGFloat rotation = [self viewRotateRadians];
    CGFloat centerMoveX = translation.x * cos(rotation) / 2;
    CGFloat centerMoveY = translation.x * sin(rotation) / 2;
    center.x = center.x + centerMoveX;
    center.y = center.y + centerMoveY;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleMiddleRightControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width + translation.x;
    bounds.size.height = bounds.size.height;
    CGFloat rotation = [self viewRotateRadians];
    CGFloat centerMoveX = translation.x * cos(rotation) / 2;
    CGFloat centerMoveY = translation.x * sin(rotation) / 2;
    center.x = center.x + centerMoveX;
    center.y = center.y + centerMoveY;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleTopLeftControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width - translation.x;
    bounds.size.height = bounds.size.height - translation.y;
    center.x = center.x + translationInSuperView.x / 2;
    center.y = center.y + translationInSuperView.y / 2;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleTopMiddleControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.height = bounds.size.height - translation.y;
    CGFloat rotation = [self viewRotateRadians];
    CGFloat centerMoveX = - translation.y * sin(rotation) / 2;
    CGFloat centerMoveY = translation.y * cos(rotation) / 2;
    center.x = center.x + centerMoveX;
    center.y = center.y + centerMoveY;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

- (void) handleTopRightControlPointTranslation:(CGPoint) translation translationInSuperView:(CGPoint) translationInSuperView
{
    CGRect bounds = self.containerView.bounds;
    CGPoint center = self.containerView.center;
    bounds.size.width = bounds.size.width + translation.x;
    bounds.size.height = bounds.size.height - translation.y;
    center.x = center.x + translationInSuperView.x / 2;
    center.y = center.y + translationInSuperView.y / 2;
    [self updatePreviousBoundsAndSuperviewBounds:bounds center:center];
}

#pragma mark - Private Helpers
- (CGFloat) centerXForMiddleControlPoints
{
    return CGRectGetMidX(self.delegate.bounds);
}

- (CGFloat) centerXForRightControlPoints
{
    return CGRectGetMaxX([self borderRectFromContainerViewBounds:self.delegate.bounds]);
}

- (CGFloat) centerYForTopControlPoints
{
    return CGRectGetMinY([self borderRectFromContainerViewBounds:self.delegate.bounds]);
}

- (CGFloat) centerYForMiddleControlPoints
{
    return CGRectGetMidY([self borderRectFromContainerViewBounds:self.delegate.bounds]);
}

- (CGFloat) centerYForBottomControlPoints
{
    return CGRectGetMaxY([self borderRectFromContainerViewBounds:self.delegate.bounds]);
}

- (CGRect) borderRectFromContainerViewBounds:(CGRect) containerViewBounds
{
    CGRect result;
    result.origin.x = [DrawingConstants controlPointSizeHalf];
    result.origin.y = [DrawingConstants controlPointSizeHalf];
    result.size.width = containerViewBounds.size.width - 2 * [DrawingConstants controlPointSizeHalf];
    result.size.height = containerViewBounds.size.height - 2 * [DrawingConstants controlPointSizeHalf];
    return result;
}

- (void) addControlPoints
{
    if (![self.delegate isKindOfClass:[TextContainerView class]]) {
        [self.delegate addSubview:self.topLeftControlPoint];
        [self.delegate addSubview:self.topMiddleControlPoint];
        [self.delegate addSubview:self.topRightControlPoint];
        [self.delegate addSubview:self.bottomLeftControlPoint];
        [self.delegate addSubview:self.bottomMiddleControlPoint];
        [self.delegate addSubview:self.bottomRightControlPoint];
    }
    [self.delegate addSubview:self.middleLeftControlPoint];
    [self.delegate addSubview:self.middleRightControlPoint];
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
    if (![self.delegate isKindOfClass:[TextContainerView class]]) {
        self.topLeftControlPoint.center = CGPointMake([DrawingConstants controlPointSizeHalf], [self centerYForTopControlPoints]);
        self.topMiddleControlPoint.center = CGPointMake([self centerXForMiddleControlPoints], [self centerYForTopControlPoints]);
        self.topRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForTopControlPoints]);
        self.bottomLeftControlPoint.center = CGPointMake([DrawingConstants controlPointSizeHalf], [self centerYForBottomControlPoints]);
        self.bottomMiddleControlPoint.center = CGPointMake([self centerXForMiddleControlPoints], [self centerYForBottomControlPoints]);
        self.bottomRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForBottomControlPoints]);
    }
    self.middleLeftControlPoint.center = CGPointMake([DrawingConstants controlPointSizeHalf], [self centerYForMiddleControlPoints]);
    self.middleRightControlPoint.center = CGPointMake([self centerXForRightControlPoints], [self centerYForMiddleControlPoints]);
}

- (CGPoint) pointBytranslation:(CGPoint)translation
             fromOriginalPoint:(CGPoint) originalPoint
{
    CGPoint result;
    result.x = originalPoint.x + translation.x;
    result.y = originalPoint.y + translation.y;
    return result;
}

- (BOOL) shouldChangeBounds:(CGRect) bounds
{
    GenericContainerView *container = (GenericContainerView *) self.delegate;
    if (bounds.size.width < [container minSize].width || bounds.size.height < [container minSize].height) {
        return  NO;
    }
    return YES;
}

- (void) updatePreviousBoundsAndSuperviewBounds:(CGRect) bounds center:(CGPoint) center;
{
    self.previousFrame = bounds;
    if ([self shouldChangeBounds:bounds]) {
        self.delegate.bounds = bounds;
        self.delegate.center = center;
    }
}

- (CGPoint) contentViewCenterInSuperView
{
    CGPoint center;
    CGRect contentViewFrame = [self borderRectFromContainerViewBounds:self.delegate.bounds];
    center.x = CGRectGetMidX(contentViewFrame);
    center.y = CGRectGetMidY(contentViewFrame);
    CGPoint result = [self.delegate convertPoint:center toView:self.delegate.superview];
    return result;
}

- (UIColor *) borderColor
{
    return [UIColor blueColor];
}

- (CGFloat) viewRotateRadians
{
    return atan2(self.containerView.transform.b, self.containerView.transform.a);
}
@end
