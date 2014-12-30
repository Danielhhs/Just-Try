//
//  TransitionEditMenuItem.h
//  iDo
//
//  Created by Huang Hongsen on 12/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuItem.h"
@class TransitionEditMenuView;
@interface TransitionEditMenuItem : EditMenuItem
@property (nonatomic, strong) NSString *animationTitle;

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(TransitionEditMenuView *) editMenu
                        action:(SEL) action
                  hasAnimation:(BOOL) hasAnimation;


@end
