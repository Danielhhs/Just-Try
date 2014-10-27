//
//  GenericContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"
#import "ReflectionView.h"

#define SHADOW_CURL_FACTOR 0.618
#define DEFAULT_SHADOW_DEPTH 0.5
#define MAX_SHADOW_DEPTH_RATIO 0.1

@interface GenericContainerView()
@property (nonatomic) BOOL showBorder;
@property (nonatomic, strong) ReflectionView *reflection;
@property (nonatomic) BOOL showShadow;
@property (nonatomic) CGRect originalContentFrame;  //DELETE when add model support
@property (nonatomic) CGFloat shadowRatio;          //DELETE when add model support
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSDictionary *attributes;
@end

@implementation GenericContainerView

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
    [[ControlPointManager sharedManager] layoutControlPoints];
    [self.reflection updateFrame];
    [self updateShadow];
}

- (void) setup
{
    self.shadowRatio = DEFAULT_SHADOW_DEPTH;
    self.originalContentFrame = [self contentViewFrame];
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowPath = [self shadowPathWithShadowDepthRatio:self.shadowRatio].CGPath;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = NO;
    [self setupGestures];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    self.attributes = attributes;
    NSNumber *rotation = attributes[[GenericContainerViewHelper rotationKey]];
    if (rotation) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [rotation floatValue] / ANGELS_PER_PI * M_PI);
    }
    NSNumber *reflection = attributes[[GenericContainerViewHelper reflectionKey]];
    if (reflection) {
        self.reflection.hidden = ![reflection boolValue];
    }
    NSNumber *reflectionAlpha = attributes[[GenericContainerViewHelper reflectionAlphaKey]];
    if (reflectionAlpha) {
        self.reflection.alpha = [reflectionAlpha floatValue];
    }
    NSNumber *reflectionSize = attributes[[GenericContainerViewHelper reflectionSizeKey]];
    if (reflectionSize) {
        self.reflection.height = [reflectionSize floatValue];
    }
    NSNumber *shadow = attributes[[GenericContainerViewHelper shadowKey]];
    if (shadow) {
        self.showShadow = [shadow boolValue];
    }
    NSNumber *shadowAlpha = attributes[[GenericContainerViewHelper shadowAlphaKey]];
    if (shadowAlpha) {
        self.layer.shadowOpacity = [shadowAlpha floatValue];
    }
    NSNumber *shadowSize = attributes[[GenericContainerViewHelper shadowSizeKey]];
    if (shadowSize) {
        self.shadowRatio = [shadowSize doubleValue];
        self.layer.shadowPath = [self shadowPathWithShadowDepthRatio:[shadowSize doubleValue]].CGPath;
    }
}

- (NSDictionary *) attributesForContent
{
    return self.attributes;
}

#pragma mark - User Interations
- (void) setupGestures
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:self.tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self addGestureRecognizer:rotation];
}

- (BOOL) resignFirstResponder
{
    [self.delegate contentViewWillResignFirstResponder:self];
    self.showBorder = NO;
    self.tap.enabled = YES;
    [[ControlPointManager sharedManager] removeAllControlPointsFromView:self];
    return [super resignFirstResponder];
}

- (BOOL) becomeFirstResponder
{
    [self.delegate contentViewWillBecomFirstResponder:self];
    self.tap.enabled = NO;
    self.showBorder = YES;
    [[ControlPointManager sharedManager] addAndLayoutControlPointsInView:self];
    return [super becomeFirstResponder];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *) gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.5 animations:^{
            self.center = [gesture locationInView:self.superview];
        }];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.center = [gesture locationInView:self.superview];
    }
}

- (void) handleRotation:(UIRotationGestureRecognizer *) gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform transform = CGAffineTransformRotate(self.transform, gesture.rotation);
        self.transform = transform;
        CGFloat rotation = atan2f(self.transform.b, self.transform.a);
        [self.delegate contentView:self didChangeAttributes:@{[GenericContainerViewHelper rotationKey] : @(rotation)}];
        gesture.rotation = 0;
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.delegate didFinishChangingInContentView:self];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:[[ControlPointManager sharedManager] borderRectFromContainerViewBounds:rect]];
    
    CGFloat middlePoint = CGRectGetMidX(rect);
    [borderPath moveToPoint:CGPointMake(middlePoint, CONTROL_POINT_SIZE_HALF)];
    [borderPath addLineToPoint:CGPointMake(middlePoint, CONTROL_POINT_SIZE_HALF + TOP_STICK_HEIGHT)];
    
    borderPath.lineWidth = 2.f;
    [[self borderStrokeColor] setStroke];
    [borderPath stroke];
}

- (UIColor *) borderStrokeColor
{
    return self.showBorder ? [UIColor blueColor] : [UIColor clearColor];
}

- (UIBezierPath *) shadowPathWithShadowDepthRatio:(CGFloat) shadowDepthRatio
{
    CGFloat curlFactor = SHADOW_CURL_FACTOR;
    CGFloat shadowDepth = MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * self.bounds.size.height;
    CGRect contentFrame = self.originalContentFrame;
    CGFloat minX = CGRectGetMinX(contentFrame);
    CGFloat minY = CGRectGetMaxY(contentFrame);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(minX, minY + shadowDepth)];
    [path addLineToPoint:CGPointMake(minX, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY + shadowDepth)];
    [path addCurveToPoint:CGPointMake(minX, minY + shadowDepth)
            controlPoint1:CGPointMake(minX + contentFrame.size.width * (1 - curlFactor), minY + shadowDepth * (1 - curlFactor))
            controlPoint2:CGPointMake(minX + contentFrame.size.width * curlFactor, minY + shadowDepth * (1 - curlFactor))];
    return path;
}

- (void) setShowShadow:(BOOL)showShadow
{
    _showShadow = showShadow;
    if (showShadow) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

- (void) updateShadow
{
    self.layer.shadowPath = [self shadowPathWithShadowDepthRatio:self.shadowRatio].CGPath;
}

#pragma mark - Other APIs
- (CGRect) contentViewFrame
{
    CGRect contentFrame;
    contentFrame.origin.x = CONTROL_POINT_SIZE_HALF;
    contentFrame.origin.y = CONTROL_POINT_SIZE_HALF + TOP_STICK_HEIGHT;
    contentFrame.size.width = self.frame.size.width - 2 * CONTROL_POINT_SIZE_HALF;
    contentFrame.size.height = self.frame.size.height - 2 * CONTROL_POINT_SIZE_HALF - TOP_STICK_HEIGHT;
    return contentFrame;
}

- (void) addSubViews
{
    [[ControlPointManager sharedManager] addAndLayoutControlPointsInView:self];
    [self addReflectionView];
}

- (void) setShowBorder:(BOOL)showBorder
{
    if (_showBorder != showBorder) {
        _showBorder = showBorder;
        [self setNeedsDisplay];
    }
}

- (BOOL) isContentFirstResponder
{
    return self.showBorder;
}

- (void) restore
{
    self.transform = CGAffineTransformIdentity;
}

- (void) addReflectionView
{
    self.reflection = [[ReflectionView alloc] initWithOriginalView:self];
    self.reflection.hidden = YES;
    [self addSubview:self.reflection];
}

- (UIImage *) contentSnapshot
{
    return nil;
}

@end
