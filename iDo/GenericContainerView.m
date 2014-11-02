//
//  GenericContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"
#import "ReflectionView.h"
#import "ShadowHelper.h"
#import "RotationHelper.h"
#import "GenericContainerViewHelper.h"
#import "KeyConstants.h"

@interface GenericContainerView()
@property (nonatomic) BOOL showBorder;
//@property (nonatomic, strong) ReflectionView *reflection;
//@property (nonatomic) BOOL showShadow;
@property (nonatomic) CGRect originalContentFrame;  //DELETE when add model support
@property (nonatomic) CGFloat shadowRatio;          //DELETE when add model support
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotation;
@property (nonatomic, strong) NSMutableDictionary *fullAttributes;
@property (nonatomic, strong) RotationIndicatorView *rotationIndicator;
@end

@implementation GenericContainerView

#pragma mark - Set Up
- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    CGRect frameValue = [attributes[[KeyConstants frameKey]] CGRectValue];
    self = [self initWithFrame:frameValue];
    if (self) {
        self.fullAttributes = [attributes mutableCopy];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
    [[ControlPointManager sharedManager] layoutControlPoints];
    [self.reflection updateFrame];
    if (CGAffineTransformIsIdentity(self.transform)) {
        self.originalContentFrame = [self contentViewFrame];
        [self.rotationIndicator applyToView:self];
    }
    [self updateShadow];
}

- (void) setTransform:(CGAffineTransform)transform
{
    BOOL oldTransformStatus = CGAffineTransformIsIdentity(self.transform);
    BOOL newTransformStatus = CGAffineTransformIsIdentity(transform);
    [super setTransform:transform];
    if (oldTransformStatus != newTransformStatus) {
        [self updateEditingStatus];
    }
    [self.rotationIndicator update];
}

- (void) setup
{
    self.shadowRatio = DEFAULT_SHADOW_DEPTH;
    self.originalContentFrame = [self contentViewFrame];
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowPath = [ShadowHelper shadowPathWithShadowDepthRatio:self.shadowRatio originalViewHeight:self.bounds.size.height originalViewContentFrame:self.originalContentFrame].CGPath;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.masksToBounds = NO;
    [self setupGestures];
    _rotationIndicator = [[RotationIndicatorView alloc] initWithFrame:self.frame];
    [_rotationIndicator applyToView:self];
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

- (NSDictionary *) attributes
{
    return [self.fullAttributes copy];
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    [GenericContainerViewHelper mergeChangedAttributes:attributes withFullAttributes:self.fullAttributes];
    [GenericContainerViewHelper applyAttribute:attributes toContainer:self];
//    NSNumber *rotation = attributes[[GenericContainerViewHelper rotationKey]];
//    if (rotation) {
//        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [rotation floatValue] / ANGELS_PER_PI * M_PI);
//    }
//    NSNumber *reflection = attributes[[GenericContainerViewHelper reflectionKey]];
//    if (reflection) {
//        self.reflection.hidden = ![reflection boolValue];
//        if (self.reflection.hidden == NO) {
//            CGFloat reflectionHeight = [self.fullAttributes[[GenericContainerViewHelper reflectionSizeKey]] floatValue];
//            [self.reflection updateReflectionWithWithReflectionHeight:reflectionHeight];
//        }
//    }
//    NSNumber *reflectionAlpha = attributes[[GenericContainerViewHelper reflectionAlphaKey]];
//    if (reflectionAlpha) {
//        self.reflection.alpha = [reflectionAlpha floatValue];
//    }
//    NSNumber *reflectionSize = attributes[[GenericContainerViewHelper reflectionSizeKey]];
//    if (reflectionSize) {
//        self.reflection.height = [reflectionSize floatValue];
//    }
//    NSNumber *shadow = attributes[[GenericContainerViewHelper shadowKey]];
//    if (shadow) {
//        self.showShadow = [shadow boolValue];
//    }
//    NSNumber *shadowAlpha = attributes[[GenericContainerViewHelper shadowAlphaKey]];
//    if (shadowAlpha) {
//        self.layer.shadowOpacity = [shadowAlpha floatValue];
//    }
//    NSNumber *shadowSize = attributes[[GenericContainerViewHelper shadowSizeKey]];
//    if (shadowSize) {
//        self.shadowRatio = [shadowSize doubleValue];
//        self.layer.shadowPath = [ShadowHelper shadowPathWithShadowDepthRatio:[shadowSize doubleValue] originalViewHeight:self.bounds.size.height originalViewContentFrame:self.originalContentFrame].CGPath;
//    }
//    NSNumber *restore = attributes[[GenericContainerViewHelper restoreKey]];
//    if (restore) {
//        [self hideRotationIndicator];
//    }
}

#pragma mark - User Interations
- (void) setupGestures
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:self.tap];
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:self.longPress];
    
    self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self addGestureRecognizer:self.rotation];
}

- (BOOL) resignFirstResponder
{
    [self.delegate contentViewWillResignFirstResponder:self];
    self.showBorder = NO;
    self.tap.enabled = YES;
    self.longPress.enabled = NO;
    self.rotation.enabled = NO;
    [[ControlPointManager sharedManager] removeAllControlPointsFromView:self];
    return [super resignFirstResponder];
}

- (BOOL) becomeFirstResponder
{
    [self.delegate contentViewWillBecomFirstResponder:self];
    self.tap.enabled = NO;
    self.longPress.enabled = YES;
    self.rotation.enabled = YES;
    self.showBorder = YES;
    [[ControlPointManager sharedManager] addAndLayoutControlPointsInView:self];
    [self updateEditingStatus];
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
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [GenericContainerViewHelper resetActualTransformWithView:self];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self applyAttributes:@{[KeyConstants rotationKey] : @(gesture.rotation)}];
        gesture.rotation = 0;
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.rotationIndicator hide];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:[[ControlPointManager sharedManager] borderRectFromContainerViewBounds:rect]];
    
    borderPath.lineWidth = 2.f;
    [[self borderStrokeColor] setStroke];
    [borderPath stroke];
}

- (UIColor *) borderStrokeColor
{
    return self.showBorder ? [UIColor blueColor] : [UIColor clearColor];
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
    self.layer.shadowPath = [ShadowHelper shadowPathWithShadowDepthRatio:self.shadowRatio originalViewHeight:self.bounds.size.height originalViewContentFrame:self.originalContentFrame].CGPath;
}

#pragma mark - Other APIs
- (CGRect) contentViewFrame
{
    CGRect contentFrame;
    contentFrame = CGRectInset(self.bounds, CONTROL_POINT_SIZE_HALF, CONTROL_POINT_SIZE_HALF);
    return contentFrame;
}

- (void) addSubViews
{
    [[ControlPointManager sharedManager] addAndLayoutControlPointsInView:self];
    [self addReflectionView];
    [self addSubview:self.rotationIndicator];
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

- (void) addReflectionView
{
    self.reflection = [[ReflectionView alloc] initWithOriginalView:self];
    self.reflection.hidden = YES;
    [self addSubview:self.reflection];
}

- (void) updateReflectionView
{
    if (CGAffineTransformIsIdentity(self.transform)) {
        [self.reflection updateFrame];
    }
}

- (UIImage *) contentSnapshot
{
    return nil;
}

- (CGSize) minSize
{
    CGSize minSize;
    minSize.height = 2 * CONTROL_POINT_SIZE_HALF + MIN_CONTENT_HEIGHT;
    minSize.width = CONTROL_POINT_SIZE_HALF * 2 + MIN_CONTENT_WIDTH;
    return minSize;
}

- (void) updateEditingStatus
{
    if (CGAffineTransformIsIdentity(self.transform)) {
        [[ControlPointManager sharedManager] enableControlPoints];
    } else {
        [[ControlPointManager sharedManager] disableControlPoints];
    }
}

- (void) hideRotationIndicator
{
    [self.rotationIndicator hide];
}

@end
