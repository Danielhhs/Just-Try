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

- (void) setSlides:(NSMutableArray *)slides
{
    _slides = slides;
    [self.thumbnailsCollectionView reloadData];
}

- (void) setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    _currentSelectedIndex = currentSelectedIndex;
    [self.thumbnailsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.cellMovingIndicator = [[ThumbnailMovingIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.cellMovingIndicator.hidden = YES;
    [self.view addSubview:self.cellMovingIndicator];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.thumbnailsCollectionView reloadData];
}

- (void) reloadData
{
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
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate slideThumbnailController:self didSelectSlideAtIndex:indexPath.row];
}

- (IBAction)addSlide:(id)sender {
    [self.delegate slideDidAddAtIndex:self.currentSelectedIndex + 1 fromSlidesThumbnailViewController:self];
}

#pragma mark - ThumbnailCollectionViewCellDelegate
- (void) thumbnailCell:(ThumbnailCollectionViewCell *)cell didRecognizeLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    NSIndexPath *indexPath = [self.thumbnailsCollectionView indexPathForCell:cell];
    self.originalIndex = indexPath.row;
    self.cellMovingIndicator.snapshot = cell.thumbnail.image;
    self.cellMovingIndicator.bounds = cell.thumbnail.bounds;
    self.cellMovingIndicator.center = [self.thumbnailsCollectionView convertPoint:cell.thumbnail.center fromView:cell];
    self.cellMovingIndicator.hidden = NO;
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
    NSMutableDictionary *selectedSlide = self.slides[self.originalIndex];
    [self.slides removeObject:selectedSlide];
    [self.slides insertObject:selectedSlide atIndex:self.toIndex];
    [UIView animateWithDuration:0.2 animations:^{
        self.cellMovingIndicator.center = [self.thumbnailsCollectionView convertPoint:cell.thumbnail.center fromView:cell];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.372 animations:^{
            [self.thumbnailsCollectionView reloadData];
        } completion:^(BOOL finished) {
            self.cellMovingIndicator.moving = NO;
            self.cellMovingIndicator.hidden = YES;
        }];
    }];
}

- (void) switchCellWithAnotherCell:(ThumbnailCollectionViewCell *) cell
{
    for (ThumbnailCollectionViewCell *visibleCell in self.thumbnailsCollectionView.visibleCells) {
        if ([self shouldSwitchSelectedCell:cell withCell:visibleCell]) {
            [UIView animateWithDuration:0.618 animations:^{
                CGRect tempFrame = visibleCell.frame;
                visibleCell.frame = cell.frame;
                cell.frame = tempFrame;
            } completion:^(BOOL finished) {
                self.toIndex = [self.thumbnailsCollectionView indexPathForCell:visibleCell].row;
            }];
        }
    }
}

- (BOOL) shouldSwitchSelectedCell:(ThumbnailCollectionViewCell *) selectedCell withCell:(ThumbnailCollectionViewCell *)cell
{
    return (cell != selectedCell) && (self.cellMovingIndicator.center.y < CGRectGetMaxY(cell.frame) && self.cellMovingIndicator.center.y > CGRectGetMinY(cell.frame));
}

@end
