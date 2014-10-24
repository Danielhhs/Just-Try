//
//  GenericContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"
#import "ControlPointManager.h"
#import "ReflectionView.h"

@interface GenericContainerView()
@property (nonatomic) BOOL showBorder;
@property (nonatomic, strong) ReflectionView *reflection;
@end

@implementation GenericContainerView

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
    [[ControlPointManager sharedManager] layoutControlPoints];
    [self.reflection updateFrame];
}

- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
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
    NSNumber *rotation = attributes[[GenericContainerViewHelper rotationKey]];
    if (rotation) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [rotation floatValue] / ANGELS_PER_PI * M_PI);
    }
    NSNumber *reflection = attributes[[GenericContainerViewHelper reflectionKey]];
    if (reflection) {
        self.reflection.hidden = ![reflection boolValue];
    }
    NSNumber *reflectionAlpha = attributes[[GenericContainerViewHelper rotationAlphaKey]];
    if (reflectionAlpha) {
        self.reflection.alpha = [reflectionAlpha floatValue];
    }
    NSNumber *reflectionSize = attributes[[GenericContainerViewHelper rotationSizeKey]];
    if (reflectionSize) {
        self.reflection.height = [reflectionSize floatValue];
    }
}

#pragma mark - User Interations
- (void) setupGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self addGestureRecognizer:rotation];
}

- (BOOL) resignFirstResponder
{
    [self.delegate contentViewWillResignFirstResponder:self];
    self.showBorder = NO;
    [[ControlPointManager sharedManager] removeAllControlPointsFromView:self];
    return [super resignFirstResponder];
}

- (BOOL) becomeFirstResponder
{
    [self.delegate contentViewWillBecomFirstResponder:self];
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
    }
}

#pragma mark - Drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
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
