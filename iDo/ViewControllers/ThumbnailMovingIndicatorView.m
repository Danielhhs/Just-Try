//
//  ThumbnailMovingIndicatorView.m
//  iDo
//
//  Created by Huang Hongsen on 11/13/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ThumbnailMovingIndicatorView.h"

@interface ThumbnailMovingIndicatorView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ThumbnailMovingIndicatorView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 3, 3)];
        [self addSubview:self.imageView];
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -3, -3)].CGPath;
    }
    return self;
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.imageView.frame = CGRectInset(self.bounds, 3, 3);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -3, -3)].CGPath;
    [self setNeedsDisplay];
}

- (void) setMoving:(BOOL)moving
{
    _moving = moving;
    if (moving) {
        [UIView animateWithDuration:0.372 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);
        } completion:nil];
    } else {
        [self.layer removeAllAnimations];
    }
}

- (void) setSnapshot:(UIImage *)snapshot
{
    _snapshot = snapshot;
    self.imageView.image = snapshot;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *border = [UIBezierPath bezierPathWithRect:rect];
    border.lineWidth = 5.f;
    border.lineJoinStyle = kCGLineJoinRound;
    [self.tintColor setStroke];
    [border stroke];
}



@end
