//
//  ProposalCollectionViwCell.m
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ProposalCollectionViewCell.h"

@interface ProposalCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation ProposalCollectionViewCell

- (void) setThumbnail:(UIImage *)thumbnail
{
    _thumbnail = thumbnail;
    self.thumbnailView.image = thumbnail;
}

- (void) setName:(NSString *)name
{
    _name = name;
    self.nameView.text = name;
}

@end
