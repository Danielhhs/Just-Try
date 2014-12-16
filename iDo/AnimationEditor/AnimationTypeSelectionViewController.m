//
//  AnimationTypeSelectionViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationTypeSelectionViewController.h"
#import "AnimationTypeTableViewCell.h"
#import "AnimationTypesGenerator.h"
#import "AnimationDescription.h"
@interface AnimationTypeSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *animationTypesTableView;
@property (nonatomic, strong) NSArray *animationTypes;
@property (nonatomic) NSInteger selectedEffectIndex;
@end

@implementation AnimationTypeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.animationTypesTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedEffectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.delegate animationEditorInitializedWithAnimation:self.animationTypes[self.selectedEffectIndex]];
}

- (void) setAnimationEvent:(AnimationEvent)animationEvent
{
    if (_animationEvent != animationEvent) {
        _animationEvent = animationEvent;
        self.animationTypes = [[AnimationTypesGenerator generator] animationTypesForContentView:self.animationTarget type:animationEvent];
        [self.animationTypesTableView reloadData];
    }
}

- (void) setAnimationTarget:(UIView *)animationTarget
{
    if (_animationTarget != animationTarget) {
        _animationTarget = animationTarget;
        self.animationTypes = [[AnimationTypesGenerator generator] animationTypesForContentView:self.animationTarget type:self.animationEvent];
        [self.animationTypesTableView reloadData];
    }
}

- (void) setAnimationEffect:(AnimationEffect)animationEffect
{
    _animationEffect = animationEffect;
    self.selectedEffectIndex = 0;
    for (AnimationDescription *animation in self.animationTypes) {
        if (animation.animationEffect == animationEffect) {
            self.selectedEffectIndex = [self.animationTypes indexOfObject:animation];
        }
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.animationTypes count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimationTypeTableViewCell"];
    
    if ([cell isKindOfClass:[AnimationTypeTableViewCell class]]) {
        AnimationDescription *animation = self.animationTypes[indexPath.row];
        cell.textLabel.text = animation.animationName;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimationDescription *animation = self.animationTypes[indexPath.row];
    animation.animationEvent = self.animationEvent;
    self.selectedEffectIndex = indexPath.row;
    [self.delegate animationEditorDidSelectAnimation:self.animationTypes[indexPath.row]];
}
@end
