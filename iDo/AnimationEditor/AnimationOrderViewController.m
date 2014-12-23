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
#import "GenericContentConstants.h"
#import "AnimationOrderCollectionViewImageCell.h"
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
    
    self.animations = [[SlideAttributesManager sharedManager] currentSlideAnimations];
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
    NSDictionary *animation = self.animations[indexPath.row];
    if ([animation[[KeyConstants contentTypeKey]] integerValue] == ContentViewTypeImage) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationOrderImageCell" forIndexPath:indexPath];
    } else if ([animation[[KeyConstants contentTypeKey]] integerValue] == ContentViewTypeText) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationOrderTextCell" forIndexPath:indexPath];
    }
    
    if ([cell isKindOfClass:[AnimationOrderCollectionViewCell class]]) {
        AnimationOrderCollectionViewCell *orderCell = (AnimationOrderCollectionViewCell *)cell;
        orderCell.index = indexPath.row;
        orderCell.contentDescriptionLabel.text = animation[[KeyConstants contentDescriptionKey]];
        orderCell.orderIndicator.event = [animation[[KeyConstants animationEventKey]] integerValue];
        orderCell.orderIndicator.hasAnimation = YES;
        orderCell.orderIndicator.animatinOrder = [animation[[KeyConstants animationIndexKey]] integerValue];
        orderCell.delegate = self;
        if ([cell isKindOfClass:[AnimationOrderCollectionViewImageCell class]]) {
            AnimationOrderCollectionViewImageCell *imageCell = (AnimationOrderCollectionViewImageCell *) cell;
            imageCell.thumbnailImageView.image = [UIImage imageNamed:animation[[KeyConstants imageNameKey]]];
        }
    }
    return cell;
}
@end
