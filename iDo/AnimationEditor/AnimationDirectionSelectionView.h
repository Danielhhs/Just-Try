//
//  AnimationDirectionSelectionView.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
@protocol AnimationDirectionSelectionViewDelegate
- (void) animationDirectionSelectionViewDidSelectDirection:(AnimationPermittedDirection) direction;
@end

@interface AnimationDirectionSelectionView : UIView

@property (nonatomic) AnimationPermittedDirection permittedDirection;
@property (nonatomic) AnimationPermittedDirection selectedDirection;
@property (nonatomic, weak) id<AnimationDirectionSelectionViewDelegate> delegate;
@end
