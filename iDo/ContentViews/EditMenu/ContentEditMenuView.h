//
//  ContentEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
#import "EditMenuView.h"
@class GenericContainerView;

@interface ContentEditMenuView : EditMenuView

@property (nonatomic, weak) GenericContainerView *triggeredContent;
- (void) showToContent:(GenericContainerView *) content animated:(BOOL) animated;
@end
