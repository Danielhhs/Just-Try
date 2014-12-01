//
//  EditMenuItem.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentEditMenuView;

typedef NS_ENUM(NSInteger, EditMenuItemType) {
    EditMenuItemTypeCommon = 0,
    EditMenuItemTypeLeftMost = 1,
    EditMenuItemTypeRightMost = 2,
    EditMenuItemTypeOnly = 3
};

@interface EditMenuItem : UIButton

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(ContentEditMenuView *) editMenu
                        action:(SEL) action;

+ (UIColor *) normalStateColor;
@property (nonatomic) EditMenuItemType type;
@end
