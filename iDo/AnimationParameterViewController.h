//
//  AnimationParameterViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationParameters.h"
@protocol AnimationParameterViewControllerDelegate
- (void) animationParameterViewControllerDidChangeAnimationParameters:(AnimationParameters *) animaitonParameters;
@end

@interface AnimationParameterViewController : UIViewController

@property (nonatomic, strong) AnimationParameters *animationParameters;
@property (nonatomic) AnimationPermittedDirection permittedDirection;
@property (nonatomic, weak) id<AnimationParameterViewControllerDelegate> delegate;
@end
