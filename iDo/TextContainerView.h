//
//  TextContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"
@class TextContainerView;
@protocol TextContainerViewDelegate <ContentContainerViewDelegate>

- (void) textViewDidSelectTextRange:(NSRange) selectedRange;

- (void) textViewDidSelectFont:(UIFont *) font;

- (void) textViewDidStartEditing:(TextContainerView *) textView;

@end

@interface TextContainerView : GenericContainerView

@property (nonatomic, strong) NSAttributedString* text;
@property (nonatomic, weak) id<TextContainerViewDelegate> delegate;

- (instancetype) initWithAttributes:(NSMutableDictionary *) attributes delegate:(id<ContentContainerViewDelegate>)delegate;

- (void) finishEditing;

- (void) adjustTextViewBoundsForBounds:(CGRect) bounds;
@end
