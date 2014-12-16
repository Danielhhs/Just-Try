//
//  AnimationParameterViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationParameterViewController.h"
#import "AnimationDirectionSelectionView.h"
#import "AnimationParameterSlider.h"
@interface AnimationParameterViewController ()
@property (weak, nonatomic) IBOutlet AnimationParameterSlider *durationSlider;
@property (weak, nonatomic) IBOutlet AnimationDirectionSelectionView *animationDirectionSelector;
@property (weak, nonatomic) IBOutlet AnimationParameterSlider *timeAfterLastAnimationSlider;

@end

@implementation AnimationParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAnimationParameters:(AnimationParameters *)animationParameters
{
    _animationParameters = animationParameters;
    [self updateUI];
}
- (void) setPermittedDirection:(AnimationPermittedDirection)permittedDirection
{
    _permittedDirection = permittedDirection;
    [self updateUI];
}

- (void) updateUI
{
    self.durationSlider.value = self.animationParameters.duration;
    self.timeAfterLastAnimationSlider.value = self.animationParameters.timeAfterPreviousAnimation;
    self.animationDirectionSelector.selectedDirection = self.animationParameters.selectedDirection;
    self.animationDirectionSelector.permittedDirection = self.animationParameters.permittedDirection;
}

@end
