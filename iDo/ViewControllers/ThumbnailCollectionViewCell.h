//
//  ThumbnailCollectionViewCell.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThumbnailCollectionViewCell;

@protocol ThumbnailCollectionViewCellDelegate
- (void) thumbnailCell:(ThumbnailCollectionViewCell *) cell didRecognizeLongPressGesture:(UILongPressGestureRecognizer *)gesture;
- (void) thumbnailCell:(ThumbnailCollectionViewCell *) cell didMoveWithLongPressGesture:(UILongPressGestureRecognizer *) translation;
- (void) thumbnailCellDidFinishMoving:(ThumbnailCollectionViewCell *)cell;
@end

@interface ThumbnailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL moving;
@property (nonatomic, weak) id<ThumbnailCollectionViewCellDelegate> delegate;
@end
