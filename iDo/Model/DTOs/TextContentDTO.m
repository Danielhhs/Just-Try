//
//  TextContentDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "TextContentDTO.h"
#import "TextFontHelper.h"
#import "DrawingConstants.h"
#define DEFAULT_TEXT_CONTAINER_WIDTH 300.f
#define DEFAULT_TEXT_CONTAINER_HEIGHT 30
#define PLACE_HOLDER_STRING @"Any Thing You Want to Say"

@implementation TextContentDTO

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.selectedRange = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

+ (TextContentDTO *) defaultText
{
    TextContentDTO *textContent = [[TextContentDTO alloc] init];
    [GenericContentDTO applyDefaultGenericContentToContentDTO:textContent];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:PLACE_HOLDER_STRING
                                                                           attributes:@{NSFontAttributeName : [TextFontHelper defaultFont],
                                                                                        NSParagraphStyleAttributeName : paragraphStyle,
                                                                                        NSForegroundColorAttributeName : [UIColor whiteColor]}];
    textContent.attributedString = attributedString;
    textContent.bounds = CGRectMake(0, 0, DEFAULT_TEXT_CONTAINER_WIDTH, 2 * [DrawingConstants controlPointSizeHalf] + DEFAULT_TEXT_CONTAINER_HEIGHT);
    textContent.contentType = ContentViewTypeText;
    textContent.center = CGPointMake(512, 384);
    textContent.backgroundColor = [UIColor clearColor];
    return textContent;
}
@end
