//
//  AnimationTypeTableViewCell.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationTypeTableViewCell.h"

@interface AnimationTypeTableViewCell ()
@end

@implementation AnimationTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = self.tintColor;
    self.selectedBackgroundView = backgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
