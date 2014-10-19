//
//  TextContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContainerView.h"

@interface TextContainerView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation TextContainerView

- (instancetype) initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:[self contentViewFrame]];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = attributedString.string;
        [self addSubViews];
    }
    return self;
}

- (void) addSubViews
{
    [self addSubview:self.textLabel];
    [super addSubViews];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLabel.frame = [self contentViewFrame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
