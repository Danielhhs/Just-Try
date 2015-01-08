//
//  UIReorderableCollectionViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReorderableCollectionViewMovingIndicator.h"
#import "UIReorderableCollectionViewCell.h"
@class UIReorderableCollectionViewController;
@protocol UIReorderableCollectionViewControllerDelegate
- (void) reorderViewController:(UIReorderableCollectionViewController *)viewController
          didSwitchCellAtIndex:(NSInteger) fromIndex
                       toIndex:(NSInteger) toIndex;
@end

@interface UIReorderableCollectionViewController : UICollectionViewController<UIReorderableCollectionViewCellDelegate>

@property (nonatomic, strong) ReorderableCollectionViewMovingIndicator *movingIndicator;
@property (nonatomic, weak) id<UIReorderableCollectionViewControllerDelegate> delegate;
- (void) refresh;
@end
