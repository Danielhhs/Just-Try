//
//  AnimationOrderViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/13/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationOrderViewController.h"
#import "AnimationOrderCollectionViewCell.h"
#import "KeyConstants.h"
#import "SlideAttributesManager.h"
#import "Enums.h"
#import "AnimationOrderCollectionViewImageCell.h"
#import "AnimationOrderDTO.h"
@interface AnimationOrderViewController ()

@end

@implementation AnimationOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.animations = [[SlideAttributesManager sharedManager] currentSlideAnimationDescriptions];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.animations count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    AnimationOrderDTO *animation = self.animations[indexPath.row];
    if (animation.viewType == ContentViewTypeImage) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationOrderImageCell" forIndexPath:indexPath];
    } else if (animation.viewType == ContentViewTypeText) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationOrderTextCell" forIndexPath:indexPath];
    }
    
    if ([cell isKindOfClass:[AnimationOrderCollectionViewCell class]]) {
        AnimationOrderCollectionViewCell *orderCell = (AnimationOrderCollectionViewCell *)cell;
        orderCell.index = indexPath.row;
        orderCell.contentDescriptionLabel.text = animation.animationDescription;
        orderCell.orderIndicator.event = animation.event;
        orderCell.orderIndicator.hasAnimation = YES;
        orderCell.orderIndicator.animatinOrder = animation.index;
        orderCell.delegate = self;
        if ([cell isKindOfClass:[AnimationOrderCollectionViewImageCell class]]) {
            AnimationOrderCollectionViewImageCell *imageCell = (AnimationOrderCollectionViewImageCell *) cell;
            imageCell.thumbnailImageView.image = [UIImage imageNamed:animation.imageName];
        }
    }
    return cell;
}

- (void) refresh
{
    self.animations = [[SlideAttributesManager sharedManager] currentSlideAnimationDescriptions];
    [self.collectionView reloadData];
}
@end
