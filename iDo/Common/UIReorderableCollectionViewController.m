//
//  UIReorderableCollectionViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "UIReorderableCollectionViewController.h"
#import "UIView+Snapshot.h"

@interface UIReorderableCollectionViewController ()
@property (nonatomic) NSInteger originalIndex;
@property (nonatomic) NSInteger toIndex;
@end

@implementation UIReorderableCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.movingIndicator = [[ReorderableCollectionViewMovingIndicator alloc] initWithFrame:CGRectZero];
    self.movingIndicator.hidden = YES;
    [self.collectionView addSubview:self.movingIndicator];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}


#pragma mark - UIReorderableCollectionViewCellDelegate
- (void) reorderableCell:(UIReorderableCollectionViewCell *)cell didRecognizeLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    self.movingIndicator.bounds = cell.bounds;
    self.movingIndicator.hidden = NO;
    self.movingIndicator.center = [self convertCellCenterToCurrentVisibleArea:cell.center];
    self.movingIndicator.moving = YES;
    self.movingIndicator.snapshot = [cell snapshot];
    cell.hidden = YES;
    self.originalIndex = [self.collectionView indexPathForCell:cell].row;
    self.toIndex = self.originalIndex;
    [UIView animateWithDuration:0.372 animations:^{
        self.movingIndicator.center = [self convertCellCenterToCurrentVisibleArea:[longPress locationInView:self.collectionView]];
    }];
}

- (void) reorderableCell:(UIReorderableCollectionViewCell *)cell didMoveWithLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    self.movingIndicator.center = [self convertCellCenterToCurrentVisibleArea:[longPress locationInView:self.collectionView]];
    [self switchCellWithAnotherCell:cell];
}

- (void) reorderableCell:(UIReorderableCollectionViewCell *)cell didFinishMovingWithLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    [UIView animateWithDuration:0.372 animations:^{
        self.movingIndicator.center = [self convertCellCenterToCurrentVisibleArea:cell.center];
    } completion:^(BOOL finished) {
        self.movingIndicator.moving = NO;
        self.movingIndicator.hidden = YES;
        cell.hidden = NO;
    }];
}

- (CGPoint) convertCellCenterToCurrentVisibleArea:(CGPoint) actualCenter
{
    CGPoint newCenter = actualCenter;
    newCenter.y -= [self.collectionView contentOffset].y;
    return newCenter;
}

- (CGPoint) convertVisibleCenterToAcutalCenter:(CGPoint) visibleCenter
{
    CGPoint newCenter = visibleCenter;
    newCenter.y += [self.collectionView contentOffset].y;
    return newCenter;
}

- (void) switchCellWithAnotherCell:(UIReorderableCollectionViewCell *) cell
{
    for (UIReorderableCollectionViewCell *visibleCell in [self.collectionView visibleCells]) {
        if ([self shouldSwitchCell:cell withVisibleCell:visibleCell]) {
            self.toIndex = visibleCell.index;
            visibleCell.index = cell.index;
            cell.index = self.toIndex;
            [UIView animateWithDuration:0.372 animations:^{
                CGRect tempFrame = cell.frame;
                cell.frame = visibleCell.frame;
                visibleCell.frame = tempFrame;
                self.originalIndex = -1;
                self.toIndex = -1;
            }];
        }
    }
}

- (BOOL) shouldSwitchCell:(UIReorderableCollectionViewCell *) cell withVisibleCell:(UIReorderableCollectionViewCell *) visibleCell
{
    CGPoint center = [self convertVisibleCenterToAcutalCenter:self.movingIndicator.center];
    return (cell != visibleCell) && center.y > CGRectGetMinY(visibleCell.frame) && center.y < CGRectGetMaxY(visibleCell.frame);
}

@end
