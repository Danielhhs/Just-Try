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
#import "AnimationOrderViewController.h"
@interface AnimationEditorContainerViewController ()<AnimationTypeSelectionViewControllerDelegate, AnimationParameterViewControllerDelegate, UIReorderableCollectionViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *editorSegment;
@property (nonatomic, strong) AnimationTypeSelectionViewController *typeSelectionViewController;
@property (nonatomic, strong) AnimationParameterViewController *parameterInputViewController;
@property (nonatomic, strong) AnimationOrderViewController *orderViewController;
@end
#define kAnimationTypeControllerIndex 0
#define kAnimationParameterControllerIndex 1
#define kAnimationOrderControllerIndex 2

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
        self.parameterInputViewController.delegate = self;
    }
    return _parameterInputViewController;
}

- (AnimationOrderViewController *) orderViewController
{
    if (!_orderViewController) {
        _orderViewController = [[UIStoryboard storyboardWithName:@"AnimationEditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"AnimationOrderViewController"];
        _orderViewController.delegate = self;
    }
    return _orderViewController;
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
    } else if (sender.selectedSegmentIndex == kAnimationOrderControllerIndex) {
        [self showAnimationOrderViewController];
    }
}

- (void) setAnimationTarget:(UIView *)animationTarget
{
    _animationTarget = animationTarget;
    self.typeSelectionViewController.animationTarget = animationTarget;
}

- (void) setAnimationIndex:(NSInteger)animationIndex
{
    _animationIndex = animationIndex;
    self.animation.animationIndex = animationIndex;
}

- (void) setAnimation:(AnimationDescription *)animation
{
    _animation = animation;
    self.typeSelectionViewController.animationEvent = animation.animationEvent;
    self.typeSelectionViewController.animationEffect = animation.animationEffect;
    self.parameterInputViewController.animationParameters = animation.parameters;
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

#pragma mark - AnimationOrderViewController
- (void) showAnimationOrderViewController
{
    [self hideAllChildViewControllers];
    [self addChildViewController:self.orderViewController];
    self.orderViewController.view.frame = CGRectOffset(self.orderViewController.view.bounds, 0, kTopBarSpace);
    [self.view addSubview:self.orderViewController.view];
    [self.orderViewController didMoveToParentViewController:self];
}

- (void) hideAnimationOrderViewController
{
    [self.orderViewController willMoveToParentViewController:nil];
    [self.orderViewController.view removeFromSuperview];
    [self.orderViewController removeFromParentViewController];
}

- (void) hideAllChildViewControllers
{
    [self hideAnimationTypeSelectionViewController];
    [self hideAnimationParameterViewController];
    [self hideAnimationOrderViewController];
}
#pragma mark - AnimationTypeSelectionViewControllerDelegate
- (void) animationEditorDidSelectAnimation:(AnimationDescription *)animation
{
    if (self.animation.animationEffect != animation.animationEffect) {
        self.animation = [animation copyWithZone:nil];
        self.parameterInputViewController.animationParameters = self.animation.parameters;
        self.parameterInputViewController.permittedDirection = self.animation.parameters.permittedDirection;
        self.animation.animationIndex = self.animationIndex;
        [self.delegate animationEditorDidUpdateAnimationEffect:self.animation];
    }
}

- (void) animationEditorInitializedWithAnimation:(AnimationDescription *)animation
{
    self.parameterInputViewController.permittedDirection = animation.parameters.permittedDirection;
}

#pragma mark - AnimationParameterViewControllerDelegate
- (void) animationParameterViewControllerDidChangeAnimationParameters:(AnimationParameters *)animaitonParameters
{
    self.animation.parameters = [animaitonParameters copyWithZone:nil];
}

#pragma mark - UIReorderableCollectionViewControllerDelegate
- (void) reorderViewController:(UIReorderableCollectionViewController *)viewController
          didSwitchCellAtIndex:(NSInteger)fromIndex
                       toIndex:(NSInteger)toIndex
{
    [self.delegate animationEditorDidSwitchAnimationAtIndex:fromIndex toIndex:toIndex];
}

#pragma mark - Memory Management
- (void) viewDidDisappear:(BOOL)animated
{
    [self.delegate animationEditorDidSelectAnimation:self.animation];
    [super viewDidDisappear:animated];
}

@end
