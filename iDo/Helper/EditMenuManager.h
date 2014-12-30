//
//  EditMenuManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditMenuView.h"

@interface EditMenuManager : NSObject

@property (nonatomic, strong) EditMenuView *editMenu;
@property (nonatomic, weak) UIView *containerView;

+ (EditMenuManager *) sharedManager;
- (void) setDelegate:(id<EditMenuViewDelegate>)delegate;
- (void) showEditMenuToView:(UIView *) view;
- (void) refreshEditMenuViewToView:(UIView *) view;
- (void) hideEditMenu;
- (void) updateEditMenu;
- (void) updateEditMenuWithView:(UIView *)view;
- (void) updateEditMenuWithAnimationName:(NSString *) animationName animationOrder:(NSInteger) animationOrder;
@end
