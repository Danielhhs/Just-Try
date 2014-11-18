//
//  EditMenuItem.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentEditMenuView;
@interface EditMenuItem : UIButton

- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *) title
                      editMenu:(ContentEditMenuView *) editMenu
                        action:(SEL) action;
@end
