//
//  ContentEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GenericContainerView;
@class ContentEditMenuView;
@protocol ContentEditMenuViewDelegate <NSObject>

- (void) editMenu:(ContentEditMenuView *) editMenu didEditContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu didDeleteContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu didCutContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu didPasteContent:(GenericContainerView *)content;

@end

@interface ContentEditMenuView : UIView

@property (nonatomic, strong) GenericContainerView *triggeredContent;
@property (nonatomic, weak) id<ContentEditMenuViewDelegate> delegate;
- (void) show;
- (void) hide;
@end
