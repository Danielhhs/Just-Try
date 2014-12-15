//
//  AnimationToolbarViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationToolbarViewController.h"
#import "AnimationModeManager.h"
@implementation AnimationToolbarViewController
- (IBAction)exitAnimationMode:(id)sender {
    [[AnimationModeManager sharedManager] exitAnimationMode];
}


- (IBAction)playEffect:(id)sender {
    [self.delegate playAnimationForCurrentSelectedView];
}

@end
