//
//  AnimationParameterViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationParameters.h"
@interface AnimationParameterViewController : UIViewController

@property (nonatomic, strong) AnimationParameters *animationParameters;
@property (nonatomic) AnimationPermittedDirection permittedDirection;
@end
