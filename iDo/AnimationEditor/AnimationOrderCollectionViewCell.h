//
//  AnimationOrderCollectionViewCell.h
//  iDo
//
//  Created by Huang Hongsen on 12/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIReorderableCollectionViewCell.h"
#import "AnimationOrderIndicatorView.h"

@interface AnimationOrderCollectionViewCell : UIReorderableCollectionViewCell
@property (weak, nonatomic) IBOutlet AnimationOrderIndicatorView *orderIndicator;
@property (weak, nonatomic) IBOutlet UILabel *contentDescriptionLabel;

@end
