//
//  TextFontHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/27/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TextAlignment) {
    TextAlignmentLeft = 0,
    TextAlignmentMiddle = 1,
    TextAlignmentRight = 2
};

@interface TextFontHelper : NSObject

+ (NSArray *) allFontFamilies;

+ (NSArray *) displayingFontNamesForEachFontFamilies;

+ (NSArray *) allSizes;

+ (NSString *) defaultFontFamily;

+ (NSString *) defaultFontNames;

+ (NSInteger) defaultFontSize;

+ (UIFont *) defaultFont;

+ (NSArray *) fullFontNames;

@end
