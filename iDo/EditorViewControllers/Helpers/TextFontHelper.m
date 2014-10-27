//
//  TextFontHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/27/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextFontHelper.h"
#define REGULAR_TEXT @"Regular"
#define FONT_SESARATOR @"-"

@implementation TextFontHelper

#define MIN_FONT_SIZE 2
#define MAX_FONT_SIEZ 100

+ (NSArray *) allFontFamilies
{
    NSMutableArray *allFonts = [NSMutableArray array];
    for (NSString *familyName in [UIFont familyNames]) {
        [allFonts addObject:familyName];
    }
    return [allFonts copy];
}

+ (NSArray *) allSizes
{
    NSMutableArray *allSizes = [NSMutableArray array];
    for (int i = MIN_FONT_SIZE; i <= MAX_FONT_SIEZ; i += 2) {
        [allSizes addObject:@(i)];
    }
    return [allSizes copy];
}

+ (NSString *) defaultFontFamily
{
    return @"Snell Roundhand";
}

+ (NSString *) defaultFontNames
{
    return REGULAR_TEXT;
}

+ (NSInteger) defaultFontSize
{
    return 36;
}

+ (UIFont *) defaultFont
{
    UIFont *font = [UIFont fontWithName:[TextFontHelper defaultFontFamily] size:[TextFontHelper defaultFontSize]];
    return font;
}

+ (NSArray *) fullFontNames
{
    NSMutableArray *fullFontNames = [NSMutableArray array];
    for (NSString *familyName in [TextFontHelper allFontFamilies]) {
        [fullFontNames addObject:[UIFont fontNamesForFamilyName:familyName]];
    }
    return fullFontNames;
}

+ (NSArray *) displayingFontNamesForEachFontFamilies
{
    NSMutableArray *allFontNames = [NSMutableArray array];
    for (NSString *familyName in [TextFontHelper allFontFamilies]) {
        NSMutableArray *fontNames = [NSMutableArray array];
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSString *displayingFontName = [TextFontHelper displayingFontNameFromFamilyName:familyName fontName:fontName];
            [fontNames addObject:displayingFontName];
        }
        [allFontNames addObject:fontNames];
    }
    return allFontNames;
}

+ (NSString *) displayingFontNameFromFamilyName:(NSString *) familyName
                                           fontName:(NSString *) fontName
{
    NSString *displayingFontName;
    NSArray *components = [fontName componentsSeparatedByString:FONT_SESARATOR];
    if ([components count] <= 1) {
        NSString *upperFamilyName = [TextFontHelper preprocessFamilyName:familyName];
        if ([fontName length] < [upperFamilyName length]) {
            displayingFontName = fontName;
        } else {
            NSString *upperFontName = [fontName uppercaseString];
            if ([upperFontName containsString:upperFamilyName]) {
                NSString *suffix = [upperFontName substringFromIndex:[upperFamilyName length]];
                if ([TextFontHelper suffixIsEmpty:suffix]) {
                    displayingFontName = REGULAR_TEXT;
                } else {
                    displayingFontName = [fontName substringFromIndex:[upperFamilyName length]];
                }
            } else  {
                displayingFontName = fontName;
            }
        }
    } else {
        displayingFontName = [components lastObject];
    }
    return displayingFontName;
}

+ (BOOL) suffixIsEmpty:(NSString *)suffix
{
    return suffix == nil || [suffix length] == 0;
}

+ (NSString *) preprocessFamilyName:(NSString *) familyName
{
    NSString *processedName = [familyName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [processedName uppercaseString];
}



@end
