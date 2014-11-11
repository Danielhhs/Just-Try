//
//  ThumbnailCollectionViewCell.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbnailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@end
