//
//  GenericContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenericContainerView;

@protocol ContentContainerViewDelegate <NSObject>

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewDidResignFirstResponder:(GenericContainerView *) contentView;

@end

@interface GenericContainerView : UIView

@property (nonatomic, weak) id<ContentContainerViewDelegate> delegate;

- (CGRect) contentViewFrame;

- (void) addSubViews;


@end
