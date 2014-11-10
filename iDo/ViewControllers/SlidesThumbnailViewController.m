//
//  SlidesThumbnailViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesThumbnailViewController.h"
#import "KeyConstants.h"

@interface SlidesThumbnailViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailsCollectionView;
@property (nonatomic, strong) NSArray *slides;
@end

static NSString *reusalbleCellIdentifier = @"thumbnailsCell";

@implementation SlidesThumbnailViewController

- (void) setProposalAttributes:(NSDictionary *)proposalAttributes
{
    _proposalAttributes = proposalAttributes;
    
    self.slides = proposalAttributes[[KeyConstants proposalSlidesKey]];
}

- (void) setSlides:(NSArray *)slides
{
    _slides = slides;
    [self.thumbnailsCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSDictionary *slide = self.slides[indexPath.row];
    UIImage *image = slide[[KeyConstants slideThumbnailKey]];
    cell.layer.contents = (__bridge id)image.CGImage;
    
    return cell;
}

@end
