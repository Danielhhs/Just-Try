//
//  RegularColorPickerCollectioinViewCell.m
//  iDo
//
//  Created by Huang Hongsen on 12/10/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RegularColorPickerCollectioinViewCell.h"
@interface RegularColorPickerCollectioinViewCell()
@property (weak, nonatomic) IBOutlet UIView *colorIndicator;
@property (weak, nonatomic) IBOutlet UIView *selectionIndicator;

@end

@implementation RegularColorPickerCollectioinViewCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void) setup
{
    self.bounds = CGRectMake(0, 0, 75, 50);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -1, -1)].CGPath;
    self.layer.shadowOpacity = 0.3;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectionIndicator.hidden = !selected;
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    self.colorIndicator.backgroundColor = color;
}

@end
