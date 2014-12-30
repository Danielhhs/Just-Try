//
//  AnimationEditMenuItem.h
//  iDo
//
//  Created by Huang Hongsen on 12/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuItem.h"
#import "AnimationConstants.h"
@class AnimationEditMenuView;
@interface AnimationEditMenuItem : EditMenuItem

@property (nonatomic) BOOL hasAnimation;
@property (nonatomic) NSInteger animationOrder;
@property (nonatomic) NSString *animationTitle;
@property (nonatomic) NSString *animationType;


- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *)title
                      subTitle:(NSString *)subtitle
                      editMenu:(AnimationEditMenuView *)editMenu
                        action:(SEL)action
                          type:(EditMenuItemType)type
                  hasAnimation:(BOOL)hasAnimation
                animationOrder:(NSInteger) animationOrder
                animationEvent:(AnimationEvent) event;
@end
