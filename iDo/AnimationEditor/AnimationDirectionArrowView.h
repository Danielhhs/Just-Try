//
//  AnimationDirectionArrowView.h
//  iDo
//
//  Created by Huang Hongsen on 12/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"

@protocol AnimationDirectionArrowViewDelegate <NSObject>

- (void) didSelectDirection:(AnimationPermittedDirection) direction;

@end

@interface AnimationDirectionArrowView : UIView

@property (nonatomic) BOOL selected;
@property (nonatomic) AnimationPermittedDirection direction;
@property (nonatomic) BOOL allowed;
@property (nonatomic, weak) id<AnimationDirectionArrowViewDelegate> delegate;
- (instancetype) initWithFrame:(CGRect)frame direction:(AnimationPermittedDirection) direction delegate:(id<AnimationDirectionArrowViewDelegate>) delegate;
@end
