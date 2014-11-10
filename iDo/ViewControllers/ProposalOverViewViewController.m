//
//  ProposalOverViewViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ProposalOverViewViewController.h"
#import "CoreDataManager.h"
#import "ProposalCollectionViewCell.h"
#import "KeyConstants.h"
#import "SlidesContainerViewController.h"

@interface ProposalOverViewViewController()<CoreDataManagerDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *proposalsCollectionView;
@property (nonatomic, strong) NSArray *proposals;
@property (nonatomic) NSInteger selectedProposalIndex;
@end

@implementation ProposalOverViewViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [CoreDataManager sharedManager].delegate = self;
    [[CoreDataManager sharedManager] openDataModelAndLoadProposals];
    self.proposalsCollectionView.dataSource = self;
}

- (void) setProposals:(NSArray *)proposals
{
    _proposals = proposals;
    [self.proposalsCollectionView reloadData];
}


#pragma mark - CoreDataManagerDelegate
- (void) managerFinishLoadingProposals:(NSArray *)proposals
{
    self.proposals = proposals;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.proposals count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"proposalCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[ProposalCollectionViewCell class]]) {
        ProposalCollectionViewCell *proposalCell = (ProposalCollectionViewCell *)cell;
        NSDictionary *attributes = self.proposals[indexPath.row];
        proposalCell.thumbnail = attributes[[KeyConstants proposalThumbnailKey]];
        proposalCell.name = attributes[[KeyConstants proposalNameKey]];
    }
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"New Proposal"]) {
        [[CoreDataManager sharedManager] createNewProposal];
    } else if ([segue.identifier isEqualToString:@"Edit Proposal"]) {
        SlidesContainerViewController *slideContainerVC = (SlidesContainerViewController *)segue.destinationViewController;
        slideContainerVC.proposalAttributes = self.proposals[self.selectedProposalIndex];
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    NSIndexPath *indexPath = [self.proposalsCollectionView indexPathForItemAtPoint:[sender locationInView:self.proposalsCollectionView]];
    self.selectedProposalIndex = indexPath.row;
    [self performSegueWithIdentifier:@"Edit Proposal" sender:self];
}

@end
