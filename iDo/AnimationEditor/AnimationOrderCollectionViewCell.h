//
//  AnimationOrderCollectionViewCell.h
//  iDo
//
//  Created by Huang Hongsen on 12/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationOrderIndicatorView.h"
@interface AnimationOrderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *contentUUIDLabel;
@property (weak, nonatomic) IBOutlet AnimationOrderIndicatorView *orderIndicator;

@end
