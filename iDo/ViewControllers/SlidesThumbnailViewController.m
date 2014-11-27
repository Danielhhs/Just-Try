//
//  SlidesThumbnailViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesThumbnailViewController.h"
#import "KeyConstants.h"
#import "ThumbnailCollectionViewCell.h"
#import "ThumbnailMovingIndicatorView.h"

@interface SlidesThumbnailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, ThumbnailCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailsCollectionView;
@property (nonatomic, strong) ThumbnailMovingIndicatorView *cellMovingIndicator;
@property (nonatomic) NSInteger originalIndex;
@property (nonatomic) NSInteger toIndex;
@end

static NSString *reusalbleCellIdentifier = @"thumbnailsCell";

@implementation SlidesThumbnailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.cellMovingIndicator = [[ThumbnailMovingIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.cellMovingIndicator.hidden = YES;
    self.originalIndex = -1;
    self.toIndex = -1;
    [self.view addSubview:self.cellMovingIndicator];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.thumbnailsCollectionView reloadData];
}

- (void) setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    UICollectionViewCell * cell = [self.thumbnailsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentSelectedIndex inSection:0]];
    cell.selected = NO;
    _currentSelectedIndex = currentSelectedIndex;
    cell = [self.thumbnailsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentSelectedIndex inSection:0]];
    cell.selected = YES;
}

- (void) setSlides:(NSMutableArray *)slides
{
    _slides = slides;
    [self.thumbnailsCollectionView reloadData];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.slides count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusalbleCellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ThumbnailCollectionViewCell class]]) {
        NSDictionary *slide = self.slides[indexPath.row];
        ThumbnailCollectionViewCell *thumbnailCell = (ThumbnailCollectionViewCell *) cell;
        thumbnailCell.indexLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
        UIImage *image = slide[[KeyConstants slideThumbnailKey]];
        thumbnailCell.thumbnail.image = image;
        thumbnailCell.delegate = self;
        thumbnailCell.index = indexPath.row;
        if (indexPath.row == self.currentSelectedIndex) {
            cell.selected = YES;
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.thumbnailsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0]].selected = NO;
    self.currentSelectedIndex = indexPath.row;
    [self.delegate slideThumbnailController:self didSelectSlideAtIndex:indexPath.row];
}

- (IBAction)addSlide:(id)sender {
    [self.delegate slideDidAddAtIndex:self.currentSelectedIndex + 1 fromSlidesThumbnailViewController:self];
}

#pragma mark - ThumbnailCollectionViewCellDelegate
- (void) thumbnailCell:(ThumbnailCollectionViewCell *)cell didRecognizeLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    UICollectionViewCell *previousSelectedCell = [self.thumbnailsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedIndex inSection:0]];
    previousSelectedCell.selected = NO;
    NSIndexPath *indexPath = [self.thumbnailsCollectionView indexPathForCell:cell];
    self.originalIndex = indexPath.row;
    self.toIndex = indexPath.row;
    self.cellMovingIndicator.bounds = cell.thumbnail.bounds;
    self.cellMovingIndicator.center = [self.thumbnailsCollectionView convertPoint:cell.thumbnail.center fromView:cell];
    self.cellMovingIndicator.hidden = NO;
    self.cellMovingIndicator.snapshot = cell.thumbnail.image;
    [UIView animateWithDuration:0.3 animations:^{
        self.cellMovingIndicator.center = [gesture locationInView:self.thumbnailsCollectionView];
    } completion:^(BOOL finished) {
        self.cellMovingIndicator.moving = YES;
    }];
}

- (void) thumbnailCell:(ThumbnailCollectionViewCell *)cell didMoveWithLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    self.cellMovingIndicator.center = [gesture locationInView:self.thumbnailsCollectionView];
    [self switchCellWithAnotherCell:cell];
}

- (void) thumbnailCellDidFinishMoving:(ThumbnailCollectionViewCell *)cell
{
    [UIView animateWithDuration:0.372 animations:^{
        self.cellMovingIndicator.center = [self.thumbnailsCollectionView convertPoint:cell.thumbnail.center fromView:cell];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.delegate slideThumbnailController:self didSwtichCellAtIndex:self.originalIndex toIndex:self.toIndex];
            [self.thumbnailsCollectionView reloadData];
        } completion:^(BOOL finished) {
            self.cellMovingIndicator.moving = NO;
            self.cellMovingIndicator.hidden = YES;
            cell.moving = NO;
            self.originalIndex = -1;
            self.toIndex = -1;
        }];
    }];
}

- (void) switchCellWithAnotherCell:(ThumbnailCollectionViewCell *) cell
{
    for (ThumbnailCollectionViewCell *visibleCell in self.thumbnailsCollectionView.visibleCells) {
        if ([self shouldSwitchSelectedCell:cell withCell:visibleCell]) {
            self.toIndex = visibleCell.index;
            visibleCell.index = cell.index;
            cell.index = self.toIndex;
            [UIView animateWithDuration:0.618 animations:^{
                CGRect tempFrame = visibleCell.frame;
                visibleCell.frame = cell.frame;
                cell.frame = tempFrame;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (BOOL) shouldSwitchSelectedCell:(ThumbnailCollectionViewCell *) selectedCell withCell:(ThumbnailCollectionViewCell *)cell
{
    return (cell != selectedCell) && (self.cellMovingIndicator.center.y < CGRectGetMaxY(cell.frame) && self.cellMovingIndicator.center.y > CGRectGetMinY(cell.frame));
}

- (void) reloadThumbnailForItemAtIndex:(NSInteger)index
{
    ThumbnailCollectionViewCell *cell = (ThumbnailCollectionViewCell *)[self.thumbnailsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    NSDictionary *slide = self.slides[index];
    cell.thumbnail.image = slide[[KeyConstants slideThumbnailKey]];
}

- (CGPoint) centerInCurrentVisibleAreaFromCenterInCollectionView:(CGPoint) center
{
    center.y -= [self.thumbnailsCollectionView contentOffset].y;
    return center;
}

@end
