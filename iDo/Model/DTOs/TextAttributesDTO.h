//
//  TextAttributesDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/7/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"

@interface TextAttributesDTO : DataTransferObject

@property (nonatomic)  NSRange selectedRange;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *selectedFont;

@end
