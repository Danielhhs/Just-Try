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
#import "GenericContainerViewHelper.h"
#import "KeyConstants.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "CompoundOperation.h"
#import "DrawingConstants.h"
#import "ReflectionHelper.h"
#import "RotationHelper.h"
#import "CanvasView.h"
#import "EditMenuManager.h"
#import "AnimationOrderManager.h"
@interface GenericContainerView()
@property (nonatomic) BOOL currentlySelected;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotation;
@property (nonatomic, strong) Operation *currentOperation;
@property (nonatomic) CGPoint originalCenter;
@end

@implementation GenericContainerView

#pragma mark - Set Up
- (instancetype) initWithAttributes:(GenericContentDTO *)attributes delegate:(id<ContentContainerViewDelegate>)delegate
{
    CGRect frameValue = [GenericContainerViewHelper frameFromAttributes:attributes];
    self = [self initWithFrame:frameValue];
    if (self) {
        self.attributes = attributes;
        self.delegate = delegate;
        self.layer.shadowOpacity = 0;
    }
    return self;
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsDisplay];
    [[ControlPointManager sharedManager] layoutControlPoints];
}

- (void) setCenter:(CGPoint)center
{
    [super setCenter:center];
    self.attributes.center = center;
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
- (void) applyAttributes:(GenericContentDTO *)attributes
{
    self.attributes = attributes;
    [GenericContainerViewHelper applyAttribute:attributes toContainer:self];
}

- (void) applyChanges:(NSDictionary *)changes
{
    [GenericContainerViewHelper mergeChangedAttributes:changes withFullAttributes:self.attributes inGenericContainer:self];
//    [GenericContainerViewHelper applyAttribute:self.attributes toContainer:self];
}

#pragma mark - User Interations
- (void) setupGestures{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:self.tap];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:self.pan];
    self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self addGestureRecognizer:self.rotation];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self addGestureRecognizer:self.longPress];
}

- (BOOL) resignFirstResponder{
    self.currentlySelected = NO;
    [[ControlPointManager sharedManager] removeAllControlPointsFromView:self];
    [[AnimationOrderManager sharedManager] hideAnimationOrderIndicator];
    return [super resignFirstResponder];
}

- (BOOL) becomeFirstResponder{
    [self.delegate contentViewWillBecomFirstResponder:self];
    self.currentlySelected = YES;
    [[ControlPointManager sharedManager] addAndLayoutControlPointsInView:self];
    [[AnimationOrderManager sharedManager] applyAnimationOrderIndicatorToView:self];
    return [super becomeFirstResponder];
}

- (void) handleTap
{
    if (self.currentlySelected == NO) {
        [self becomeFirstResponder];
    }
    [[EditMenuManager sharedManager] showEditMenuToView:self];
}

- (void) handlePan:(UIPanGestureRecognizer *) gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.center;
        [self hideSupplementaryViewsWhenStartChangingAttributes];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.superview];
        self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        SimpleOperation *centerOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants centerKey] fromValue:[NSValue valueWithCGPoint:self.originalCenter]];
        centerOperation.toValue = [NSValue valueWithCGPoint:self.center];
        [[UndoManager sharedManager] pushOperation:centerOperation];
        [self applySupplimentaryViewsWhenFinishChangingAttributes];
    }
}

- (void) handleRotation:(UIRotationGestureRecognizer *) gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [GenericContainerViewHelper resetActualTransformWithView:self];
        [self hideSupplementaryViewsWhenStartChangingAttributes];
        NSValue *fromValue = [NSValue valueWithCGAffineTransform:self.transform];
        self.currentOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants transformKey] fromValue:fromValue];
        [RotationHelper applyRotationIndicatorToView:self];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [GenericContainerViewHelper applyRotation:gesture.rotation toView:self];
        [RotationHelper updateRotationIndicator];
        [[AnimationOrderManager sharedManager] updateAnimationOrderIndicatorToView:self];
        gesture.rotation = 0;
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [RotationHelper hideRotationIndicator];
        self.attributes.transform = self.transform;
        ((SimpleOperation *)self.currentOperation).toValue = [NSValue valueWithCGAffineTransform:self.transform];
        [[UndoManager sharedManager] pushOperation:self.currentOperation];
        [self applySupplimentaryViewsWhenFinishChangingAttributes];
    }
}

- (void) handleLongPress
{
    
}

#pragma mark - Other APIs
- (CGRect) contentViewFrameFromBounds:(CGRect) bounds
{
    CGRect contentFrame;
    contentFrame = CGRectInset(bounds, [DrawingConstants controlPointSizeHalf], [DrawingConstants controlPointSizeHalf]);
    return contentFrame;
}

- (BOOL) isContentFirstResponder{
    return self.currentlySelected;
}

- (void) updateReflectionView{
    [self.reflection updateFrame];
}

- (UIImage *) contentSnapshot{
    return nil;
}

- (void) changeBackgroundColor:(UIColor *)color
{};

- (CGSize) minSize{
    CGSize minSize;
    minSize.height = 2 * [DrawingConstants controlPointSizeHalf] + MIN_CONTENT_HEIGHT;
    minSize.width = [DrawingConstants controlPointSizeHalf] * 2 + MIN_CONTENT_WIDTH;
    return minSize;
}

- (void) pushUnsavedOperation
{}

- (UIView *) contentView{
    return nil;
}

#pragma mark - OperationTarget
- (void) performOperation:(Operation *)operation{
    SimpleOperation *simpleOperation = (SimpleOperation *) operation;
    [self.delegate contentView:self willBeModifiedInCanvas:self.canvas];
    if ([simpleOperation.key isEqualToString:[KeyConstants addKey]]) {
        [self.canvas addSubview:self];
        [self becomeFirstResponder];
    } else if ([simpleOperation.key isEqualToString:[KeyConstants deleteKey]]) {
        [self removeFromSuperview];
        [[EditMenuManager sharedManager] hideEditMenu];
    } else {
        NSDictionary *attibutes = @{simpleOperation.key : simpleOperation.toValue};
        [self becomeFirstResponder];
        [self applyChanges:attibutes];
    }
    [ShadowHelper applyShadowToGenericContainerView:self];
    [ReflectionHelper applyReflectionViewToGenericContainerView:self];
    [self.delegate contentViewDidPerformUndoRedoOperation:self];
}

#pragma mark - ControlPointManagerDelegate
- (void) controlPointDidFinishMoving
{
    self.attributes.center = self.center;
    self.attributes.bounds = self.bounds;
    [self applySupplimentaryViewsWhenFinishChangingAttributes];
}

- (void) controlPointDidStartMoving
{
    [self hideSupplementaryViewsWhenStartChangingAttributes];
}

- (void) hideSupplementaryViewsWhenStartChangingAttributes
{
    [self.delegate contentView:self startChangingAttribute:[KeyConstants transformKey]];
    [ShadowHelper hideShadowForGenericContainerView:self];
    [ReflectionHelper hideReflectionViewFromGenericContainerView:self];
    [[AnimationOrderManager sharedManager] hideAnimationOrderIndicator];
}

- (void) applySupplimentaryViewsWhenFinishChangingAttributes
{
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
    [ShadowHelper applyShadowToGenericContainerView:self];
    [ReflectionHelper applyReflectionViewToGenericContainerView:self];
    [[AnimationOrderManager sharedManager] applyAnimationOrderIndicatorToView:self];
    [[EditMenuManager sharedManager] showEditMenuToView:self];
    [self.delegate contentView:self didChangeAttributes:nil];
}

- (void) contentHasBeenAddedToSuperView
{
    [ShadowHelper applyShadowToGenericContainerView:self];
    [ReflectionHelper applyReflectionViewToGenericContainerView:self];
}

- (NSArray *) animationAttributes
{
    return self.attributes.animations;
}

@end
