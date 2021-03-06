//
//  CanvasView.m
//  iDo
//
//  Created by Huang Hongsen on 10/31/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CanvasView.h"
#import "KeyConstants.h"
#import "GenericContainerViewHelper.h"
#import "EditMenuManager.h"
#import "GenericContentDTO.h"

@interface CanvasView ()
@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@property (nonatomic, weak) id<ContentContainerViewDelegate> contentDelegate;
@property (nonatomic, strong) UITapGestureRecognizer *tapToGainFocus;
@end

@implementation CanvasView

- (void) setupWithAttributes:(SlideDTO *) attributes
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[GenericContainerView class]]) {
            [subview removeFromSuperview];
        }
    }
    UIImage *background = [UIImage imageNamed:attributes.backgroundImage];
    self.layer.contents = (__bridge id)background.CGImage;
    NSArray *contents = attributes.contents;
    for (GenericContentDTO *content in contents) {
        GenericContainerView *contentView = [GenericContainerViewHelper contentViewFromAttributes:content delegate:self.contentDelegate];
        contentView.canvas = self;
        [self addSubview:contentView];
        [contentView contentHasBeenAddedToSuperView];
    }
}

- (instancetype) initWithSlideAttributes:(SlideDTO *)attributes delegate:(id<CanvasViewDelegate>)delegate contentDelegate:(id)contentDelegate
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.contentDelegate = contentDelegate;
        self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:self.pinch];
        self.tapToGainFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToGainFocus:)];
        [self addGestureRecognizer:self.tapToGainFocus];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -10, -10)].CGPath;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 5;
        self.layer.masksToBounds = NO;
        [self setupWithAttributes:attributes];
    }
    return self;
}

- (void) handlePinch:(UIPinchGestureRecognizer *) pinch
{
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
        [[EditMenuManager sharedManager] hideEditMenu];
    } else if (pinch.state == UIGestureRecognizerStateEnded || pinch.state == UIGestureRecognizerStateCancelled) {
        self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
        CGAffineTransform finalTransform = self.transform;
        if (self.transform.a > 1) {
            finalTransform = CGAffineTransformIdentity;
        } else if (self.transform.a < 0.5) {
            finalTransform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        }
        [UIView animateWithDuration:0.372 animations:^{
            self.transform = finalTransform;
        } completion:^(BOOL finished) {
            [[EditMenuManager sharedManager] showEditMenuToView:self];
        }];
        pinch.scale = 1;
    }
}

- (void) handleTapToGainFocus:(UITapGestureRecognizer *) tap
{
    [self.delegate userDidTapInCanvas:self];
}

- (void) disablePinch
{
    self.pinch.enabled = NO;
}

- (void) enablePinch
{
    self.pinch.enabled = YES;
}

@end
