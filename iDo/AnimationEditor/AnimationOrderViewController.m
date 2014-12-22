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
@interface AnimationOrderViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *animationOrderCollectionView;

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimationOrderCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[AnimationOrderCollectionViewCell class]]) {
        AnimationOrderCollectionViewCell *orderCell = (AnimationOrderCollectionViewCell *)cell;
        NSDictionary *animation = self.animations[indexPath.row];
        orderCell.contentUUIDLabel.text = [animation[[KeyConstants contentUUIDKey]] UUIDString];
        orderCell.orderIndicator.event = [animation[[KeyConstants animationEventKey]] integerValue];
        orderCell.orderIndicator.hasAnimation = YES;
        orderCell.orderIndicator.animatinOrder = [animation[[KeyConstants animationIndexKey]] integerValue];
    }
    return cell;
}
@end
