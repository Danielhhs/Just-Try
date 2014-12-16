//
//  AnimationDirectionSelectionView.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
@interface AnimationDirectionSelectionView : UIView

@property (nonatomic) AnimationPermittedDirection permittedDirection;
@property (nonatomic) AnimationPermittedDirection selectedDirection;
@end
