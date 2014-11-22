//
//  ReflectionShadowTypeCell.m
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ReflectionShadowTypeCell.h"
@interface ReflectionShadowTypeCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation ReflectionShadowTypeCell

- (void) setup
{
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:self.label];
}

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

- (void) setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
}

@end
