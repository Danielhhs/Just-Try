//
//  ReorderableCollectionViewMovingIndicator.m
//  iDo
//
//  Created by Huang Hongsen on 12/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ReorderableCollectionViewMovingIndicator.h"

@implementation ReorderableCollectionViewMovingIndicator

- (void) setMoving:(BOOL)moving
{
    _moving = moving;
    if (moving) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.03, 1.03);
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void) setSnapshot:(UIImage *)snapshot
{
    _snapshot = snapshot;
    self.layer.contents = (__bridge id)snapshot.CGImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
