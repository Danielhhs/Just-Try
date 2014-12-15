//
//  AnimationEditorContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationEditorContainerViewController.h"
#import "AnimationTypeSelectionViewController.h"
#import "AnimationParameterViewController.h"
@interface AnimationEditorContainerViewController ()<AnimationTypeSelectionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *editorSegment;
@property (nonatomic, strong) AnimationTypeSelectionViewController *typeSelectionViewController;
@property (nonatomic, strong) AnimationParameterViewController *parameterInputViewController;
@end
#define kAnimationTypeControllerIndex 0
#define kAnimationParameterControllerIndex 1

#define kTopBarSpace 50

@implementation AnimationEditorContainerViewController

- (AnimationTypeSelectionViewController *) typeSelectionViewController {
    
    if (!_typeSelectionViewController) {
        _typeSelectionViewController = [[UIStoryboard storyboardWithName:@"AnimationEditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"AnimationTypeSelectionViewController"];
        _typeSelectionViewController.delegate = self;
    }
    return _typeSelectionViewController;
}

- (AnimationParameterViewController *) parameterInputViewController
{
    if (!_parameterInputViewController) {
        _parameterInputViewController = [[UIStoryboard storyboardWithName:@"AnimationEditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"AnimationParameterViewController"];
    }
    return _parameterInputViewController;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showAnimationTypeSelectionViewController];
    self.editorSegment.selectedSegmentIndex = kAnimationTypeControllerIndex;
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == kAnimationTypeControllerIndex) {
        [self showAnimationTypeSelectionViewController];
    } else if (sender.selectedSegmentIndex == kAnimationParameterControllerIndex) {
        [self showAnimationParameterViewController];
    }
}

- (void) setAnimationTarget:(UIView *)animationTarget
{
    _animationTarget = animationTarget;
    self.typeSelectionViewController.animationTarget = animationTarget;
}

- (void) setAnimationType:(AnimationEvent)animationEvent
{
    _animationEvent = animationEvent;
    self.typeSelectionViewController.animationEvent = animationEvent;
}

#pragma mark - AnimationTypeSelectionViewController
- (void) showAnimationTypeSelectionViewController
{
    [self hideAllChildViewControllers];
    [self addChildViewController:self.typeSelectionViewController];
    self.typeSelectionViewController.view.frame = CGRectOffset(self.typeSelectionViewController.view.bounds, 0, kTopBarSpace);
    [self.view addSubview:self.typeSelectionViewController.view];
    [self.typeSelectionViewController didMoveToParentViewController:self];
}

- (void) hideAnimationTypeSelectionViewController
{
    [self.typeSelectionViewController willMoveToParentViewController:nil];
    [self.typeSelectionViewController.view removeFromSuperview];
    [self.typeSelectionViewController removeFromParentViewController];
}

#pragma mark - AnimationParameterViewController
- (void) showAnimationParameterViewController
{
    [self hideAllChildViewControllers];
    [self addChildViewController:self.parameterInputViewController];
    self.parameterInputViewController.view.frame = CGRectOffset(self.typeSelectionViewController.view.bounds, 0, kTopBarSpace);
    [self.view addSubview:self.parameterInputViewController.view];
    [self.parameterInputViewController didMoveToParentViewController:self];
}

- (void) hideAnimationParameterViewController
{
    [self.parameterInputViewController willMoveToParentViewController:nil];
    [self.parameterInputViewController.view removeFromSuperview];
    [self.parameterInputViewController removeFromParentViewController];
}

- (void) hideAllChildViewControllers
{
    [self hideAnimationTypeSelectionViewController];
    [self hideAnimationParameterViewController];
}
#pragma mark - AnimationTypeSelectionViewControllerDelegate
- (void) animationEditorDidSelectAnimation:(AnimationDescription *)animation
{
    [self.delegate animationEditorDidSelectAnimation:animation];
}

@end
