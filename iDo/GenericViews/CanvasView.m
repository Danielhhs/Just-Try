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

@interface CanvasView ()
@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@end

@implementation CanvasView

- (void) setupWithAttributes:(NSDictionary *) attributes
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    UIImage *background = [UIImage imageNamed:attributes[[KeyConstants slideBackgroundKey]]];
    self.layer.contents = (__bridge id)background.CGImage;
    
    NSArray *contents = attributes[[KeyConstants slideContentsKey]];
    id<ContentContainerViewDelegate> contentDelegate = nil;
    if ([self.delegate conformsToProtocol:@protocol(ContentContainerViewDelegate)]) {
        contentDelegate = (id<ContentContainerViewDelegate>)self.delegate;
    }
    for (NSMutableDictionary *content in contents) {
        GenericContainerView *contentView = [GenericContainerViewHelper contentViewFromAttributes:content delegate:contentDelegate];
        [self addSubview:contentView];
        [contentView resignFirstResponder];
    }
        
}

- (instancetype) initWithAttributes:(NSDictionary *)attributes
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:self.pinch];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
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
        }];
        pinch.scale = 1;
    }
}

- (void) handleTap:(UITapGestureRecognizer *) tap
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
