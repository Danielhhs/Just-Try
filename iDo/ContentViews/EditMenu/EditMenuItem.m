//
//  EditMenuItem.m
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuItem.h"
#import "ContentEditMenuView.h"
@interface EditMenuItem()
@property (nonatomic, weak) ContentEditMenuView *editMenu;
@end

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
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:editMenu action:action forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchBegins) forControlEvents:(UIControlEventTouchDown | UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(touchEnds) forControlEvents:(UIControlEventTouchDragExit | UIControlEventTouchCancel)];
    }
    return self;
}

- (void) touchBegins
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
}

- (void) touchEnds
{
    self.backgroundColor = [UIColor clearColor];
}

@end
