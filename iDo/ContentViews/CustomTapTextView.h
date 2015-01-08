//
//  CustomTapTextView.h
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextContentDTO.h"
@class CustomTapTextView;

@protocol CustomTapTextViewDelegate <UITextViewDelegate>

- (void) textView:(CustomTapTextView *)textView didSelectFont:(UIFont *) font;

- (void) textViewWillChangeSelection:(CustomTapTextView *)textView;

- (void) textViewDidChangeAttributedText:(CustomTapTextView *)textView;

@end

@interface CustomTapTextView : UITextView

@property (nonatomic, weak) id<CustomTapTextViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame attributes:(TextContentDTO *) attributes;

- (void) readyToEdit;
- (void) finishEditing;

@end
