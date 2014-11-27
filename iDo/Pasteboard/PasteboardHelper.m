//
//  PasteboardHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/27/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "PasteboardHelper.h"

#define PAST_BOARD_TYPE_UTI @"cn.hshuang.iDO"

@implementation PasteboardHelper

+ (void) clearPasteboard
{
    [[UIPasteboard generalPasteboard] setData:nil forPasteboardType:PAST_BOARD_TYPE_UTI];
}

+ (void) copyData:(NSData *)data
{
    [[UIPasteboard generalPasteboard] setData:data forPasteboardType:PAST_BOARD_TYPE_UTI];
}

+ (NSData *) dataFromPasteboard
{
    return [[UIPasteboard generalPasteboard] dataForPasteboardType:PAST_BOARD_TYPE_UTI];
}
@end
