//
//  TextDisplayView.h
//  iDo
//
//  Created by Huang Hongsen on 10/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextDisplayView;
@protocol TextDisplayViewDelegate <NSObject>

- (void) handleTapOnTextDisplayView:(TextDisplayView *)textDisplayView;

@end

@interface TextDisplayView : UIView
@property (nonatomic, weak) id<TextDisplayViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame
                    attributes:(NSDictionary *) attributes
         correspondintTextView:(UITextView *) textView
                      delegate:(id<TextDisplayViewDelegate>)delegate;

@end
