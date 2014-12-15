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
@end

@implementation AnimationTypeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) setAnimationType:(AnimationType)animationType
{
    if (_animationType != animationType) {
        _animationType = animationType;
        self.animationTypes = [[AnimationTypesGenerator generator] animationTypesForContentView:self.animationTarget type:animationType];
        [self.animationTypesTableView reloadData];
    }
}

- (void) setAnimationTarget:(UIView *)animationTarget
{
    if (_animationTarget != animationTarget) {
        _animationTarget = animationTarget;
        self.animationTypes = [[AnimationTypesGenerator generator] animationTypesForContentView:self.animationTarget type:self.animationType];
        [self.animationTypesTableView reloadData];
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
    [self.delegate animationEditorDidSelectAnimation:self.animationTypes[indexPath.row]];
}
@end
