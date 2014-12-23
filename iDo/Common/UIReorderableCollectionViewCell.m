//
//  UIReorderableCollectionViewCell.m
//  iDo
//
//  Created by Huang Hongsen on 12/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "UIReorderableCollectionViewCell.h"

@implementation UIReorderableCollectionViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void) setup
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.delegate reorderableCell:self didRecognizeLongPressGesture:gesture];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.delegate reorderableCell:self didMoveWithLongPressGesture:gesture];
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.delegate reorderableCell:self didFinishMovingWithLongPressGesture:gesture];
    }
}

@end
