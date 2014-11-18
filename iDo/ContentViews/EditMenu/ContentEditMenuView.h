//
//  ContentEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GenericContainerView;
@interface ContentEditMenuView : UIView

@property (nonatomic, strong) GenericContainerView *triggeredContent;
- (void) show;
- (void) hide;
@end
