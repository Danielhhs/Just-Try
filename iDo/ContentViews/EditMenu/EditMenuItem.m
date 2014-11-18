//
//  EditMenuItem.m
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuItem.h"
#import "ContentEditMenuView.h"
@implementation EditMenuItem

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(ContentEditMenuView *) editMenu
                        action:(SEL) action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleShadowColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



@end
