//
//  EditMenuManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentEditMenuView.h"

@interface EditMenuManager : NSObject

@property (nonatomic, strong) ContentEditMenuView *editMenu;
@property (nonatomic, weak) UIView *containerView;

+ (EditMenuManager *) sharedManager;
- (void) showEditMenuToView:(UIView *) view;
- (void) hideEditMenu;
- (void) updateEditMenu;
- (void) updateEditMenuWithAnimationName:(NSString *) animationName;
@end
