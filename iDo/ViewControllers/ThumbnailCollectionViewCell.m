//
//  ThumbnailCollectionViewCell.m
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"

@interface ThumbnailCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *movingMask;
@end

@implementation ThumbnailCollectionViewCell

- (void) awakeFromNib
{
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longpress];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.selectedIndicator.hidden = NO;
    } else {
        self.selectedIndicator.hidden = YES;
    }
}

- (void) setMoving:(BOOL)moving
{
    _moving = moving;
    self.movingMask.hidden = !moving;
    self.thumbnail.hidden = moving;
}

- (void) handleLongPress:(UILongPressGestureRecognizer *) gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.delegate thumbnailCell:self didRecognizeLongPressGesture:gesture];
        self.moving = YES;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.delegate thumbnailCell:self didMoveWithLongPressGesture:gesture];
    } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate thumbnailCellDidFinishMoving:self];
    }
}

@end
