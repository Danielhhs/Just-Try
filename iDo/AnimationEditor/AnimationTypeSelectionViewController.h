//
//  AnimationTypeSelectionViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationEditorManager.h"
@interface AnimationTypeSelectionViewController : UIViewController

@property (nonatomic) AnimationType animationType;
@property (nonatomic, weak) UIView *animationTarget;

@end
