//
//  CanvasView.m
//  iDo
//
//  Created by Huang Hongsen on 10/31/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CanvasView.h"

@interface CanvasView ()
@property (nonatomic, strong) UIPinchGestureRecognizer *pinch;
@end

@implementation CanvasView

- (void) setup
{
    self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:self.pinch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
        
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
