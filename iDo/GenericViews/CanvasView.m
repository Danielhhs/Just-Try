//
//  CanvasView.m
//  iDo
//
//  Created by Huang Hongsen on 10/31/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (void) handlePinch:(UIPinchGestureRecognizer *) pinch
{
    self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
}

@end
