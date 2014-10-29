//
//  CoreTextHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CoreTextHelper.h"
#import <UIKit/UIKit.h>

@implementation CoreTextHelper

+ (CTLineBreakMode) CTLineBreakModeFromNSLineBreakMode:(NSLineBreakMode) lineBreakMode
{
    CTLineBreakMode ctLineBreakMode;
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping:
            ctLineBreakMode = kCTLineBreakByWordWrapping;
            break;
        case NSLineBreakByClipping:
            ctLineBreakMode = kCTLineBreakByClipping;
            break;
        case NSLineBreakByCharWrapping:
            ctLineBreakMode = kCTLineBreakByCharWrapping;
            break;
        case NSLineBreakByTruncatingHead:
            ctLineBreakMode = kCTLineBreakByTruncatingHead;
            break;
        case NSLineBreakByTruncatingMiddle:
            ctLineBreakMode = kCTLineBreakByTruncatingMiddle;
            break;
        case NSLineBreakByTruncatingTail:
            ctLineBreakMode = kCTLineBreakByTruncatingTail;
            break;
        default:
            ctLineBreakMode = kCTLineBreakByWordWrapping;
            break;
    }
    return ctLineBreakMode;
}

+ (CTTextAlignment) CTTextAlignmentFromNSTextAlignment:(NSTextAlignment) textAlignment
{
    CTTextAlignment alignment;
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            alignment = kCTCenterTextAlignment;
            break;
        case NSTextAlignmentJustified:
            alignment = kCTJustifiedTextAlignment;
            break;
        case NSTextAlignmentLeft:
            alignment = kCTLeftTextAlignment;
            break;
        case NSTextAlignmentNatural:
            alignment = kCTTextAlignmentNatural;
            break;
        case NSTextAlignmentRight:
            alignment = kCTRightTextAlignment;
            break;
        default:
            alignment = kCTCenterTextAlignment;
            break;
    }
    return alignment;
}

+ (NSDictionary *) CTAttributesFromUIAttributes:(NSDictionary *)uiAttributes
{
    NSMutableDictionary *ctAttributes = [NSMutableDictionary dictionary];
    for (NSString *key in uiAttributes) {
        if ([key isEqualToString:NSFontAttributeName]) {
            UIFont *font = uiAttributes[key];
            CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
            [ctAttributes setValue:(__bridge id)fontRef forKey:(NSString *)kCTFontAttributeName];
        } else if ([key isEqualToString:NSForegroundColorAttributeName]) {
            UIColor *foreGroundColor = uiAttributes[key];
            [ctAttributes setValue:(__bridge id)foreGroundColor.CGColor forKey:(NSString *) kCTForegroundColorAttributeName];
        } else if ([key isEqualToString:NSParagraphStyleAttributeName]) {
            NSParagraphStyle *paragraphStyle = [uiAttributes objectForKey:key];
            CTLineBreakMode lineBreakMode = [CoreTextHelper CTLineBreakModeFromNSLineBreakMode:paragraphStyle.lineBreakMode];
            CTTextAlignment textAlignment = [CoreTextHelper CTTextAlignmentFromNSTextAlignment:paragraphStyle.alignment];
            CTParagraphStyleSetting setting[] = {{kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment},
                {kCTParagraphStyleSpecifierLineBreakMode, sizeof(lineBreakMode), &lineBreakMode}};
            CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(setting, sizeof(setting)/sizeof(setting[0]));
            [ctAttributes setValue:(__bridge id)paragraphStyleRef forKey:(NSString *)kCTParagraphStyleAttributeName];
        }
    }
    
    return ctAttributes;
}

+ (NSAttributedString *) CTAttributedStringFromUIAttributedString:(NSAttributedString *) uiAttributedString
{
    NSMutableAttributedString *ctAttributedString = [[NSMutableAttributedString alloc] initWithString:uiAttributedString.string
                                                                                           attributes:nil];
    NSRange fullRange = NSMakeRange(0, [uiAttributedString length]);
    [uiAttributedString enumerateAttributesInRange:fullRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSDictionary *ctAttribtues = [self CTAttributesFromUIAttributes:attrs];
        [ctAttributedString addAttributes:ctAttribtues range:range];
    }];
    return [ctAttributedString copy];
}

+ (CGFloat) heightForAttributedStringInTextView:(UITextView *)textView
{
    CGFloat maxWidth = textView.bounds.size.width - textView.textContainerInset.left - textView.textContainerInset.right;
    CGFloat height = [CoreTextHelper heightForAttributedString:textView.attributedText maxWidth:maxWidth] + textView.textContainerInset.top + textView.textContainerInset.bottom;
    return height;
}

+ (CGFloat) heightForAttributedString:(NSAttributedString *)attrString maxWidth:(CGFloat) maxWidth
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [attrString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options context:nil].size;
    CGFloat height = ceilf(size.height);
    return height;
}

@end
