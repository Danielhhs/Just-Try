//
//  GenericContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerViewHelper.h"
#import "ControlPointManager.h"

@class GenericContainerView;

@protocol ContentContainerViewDelegate <NSObject>

- (void) contentViewWillBecomFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewWillResignFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewDidResignFirstResponder:(GenericContainerView *) contentView;

- (void) contentView:(GenericContainerView *) contentView
 didChangeAttributes: (NSDictionary *) attributes;

- (void) didFinishChangingInContentView:(GenericContainerView *) contentView;
@end

@interface GenericContainerView : UIView

@property (nonatomic, weak) id<ContentContainerViewDelegate> delegate;
- (NSDictionary *) attributes;

- (instancetype) initWithAttributes:(NSDictionary *) attributes;

- (CGSize) minSize;

- (BOOL) isContentFirstResponder;

- (CGRect) contentViewFrame;

- (UIImage *) contentSnapshot;

- (void) addSubViews;

- (void) applyAttributes:(NSDictionary *) attributes;

- (void) restore;

- (void) addReflectionView;

- (void) updateReflectionView;

- (void) updateEditingStatus;

- (void) disableEditing;
- (void) enableEditing;

@end
