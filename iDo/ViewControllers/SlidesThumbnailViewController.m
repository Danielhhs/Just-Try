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

@interface SlidesThumbnailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailsCollectionView;
@end

static NSString *reusalbleCellIdentifier = @"thumbnailsCell";

@implementation SlidesThumbnailViewController

- (void) setSlides:(NSArray *)slides
{
    _slides = slides;
    [self.thumbnailsCollectionView reloadData];
}

- (void) setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    _currentSelectedIndex = currentSelectedIndex;
    [self.thumbnailsCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

@end
