//
//  UIReorderableCollectionViewCell.h
//  iDo
//
//  Created by Huang Hongsen on 12/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIReorderableCollectionViewCell;
@protocol UIReorderableCollectionViewCellDelegate <NSObject>

- (void) reorderableCell:(UIReorderableCollectionViewCell *) cell didRecognizeLongPressGesture:(UILongPressGestureRecognizer *) longPress;
- (void) reorderableCell:(UIReorderableCollectionViewCell *) cell didMoveWithLongPressGesture:(UILongPressGestureRecognizer *) longPress;
- (void) reorderableCell:(UIReorderableCollectionViewCell *) cell didFinishMovingWithLongPressGesture:(UILongPressGestureRecognizer *)longPress;

@end

@interface UIReorderableCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<UIReorderableCollectionViewCellDelegate> delegate;
@property (nonatomic) NSInteger index;
@end
