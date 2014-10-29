//
//  CoreTextHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface CoreTextHelper : NSObject
+ (NSAttributedString *) CTAttributedStringFromUIAttributedString:(NSAttributedString *) uiAttributedString;

+ (CGFloat) heightForAttributedString:(NSAttributedString *)attrString maxWidth:(CGFloat) maxWidth;

+ (CGFloat) heightForAttributedStringInTextView:(UITextView *) textView;
@end
