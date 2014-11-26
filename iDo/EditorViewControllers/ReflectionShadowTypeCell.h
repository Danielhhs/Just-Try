//
//  RefectionShadowTypeCell.h
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReflectionShadowTypeCell;
@protocol ReflectionShadowCellDelegate <NSObject>

- (void) cellDidTapped:(ReflectionShadowTypeCell *) cell;

@end

@interface ReflectionShadowTypeCell : UICollectionViewCell

@property (nonatomic, weak) id<ReflectionShadowCellDelegate> delegate;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) NSInteger type;

@end
