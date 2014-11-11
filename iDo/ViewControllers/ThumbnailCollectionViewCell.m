//
//  ThumbnailCollectionViewCell.m
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ThumbnailCollectionViewCell.h"

@implementation ThumbnailCollectionViewCell

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.selectedIndicator.hidden = NO;
    } else {
        self.selectedIndicator.hidden = YES;
    }
}
@end
