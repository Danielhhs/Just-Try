//
//  TextContentDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "GenericContentDTO.h"

@interface TextContentDTO : GenericContentDTO
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic) NSRange selectedRange;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) UITextAlignment textAlignment;
+ (TextContentDTO *) defaultText;
@end
