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

- (void) textViewDidStartEditing:(TextContainerView *) textView;

@end

@interface TextContainerView : GenericContainerView

@property (nonatomic, strong) NSAttributedString* text;
@property (nonatomic, weak) id<TextContainerViewDelegate> delegate;

- (instancetype) initWithAttributes:(NSDictionary *) attributes;

- (void) startEditing;

- (void) finishEditing;

- (void) adjustTextViewBoundsAndContainerBounds;
@end
