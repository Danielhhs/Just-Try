//
//  GenericContainerViewHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerViewHelper.h"
#import <UIKit/UIKit.h>
#import "TextFontHelper.h"
#import "ShadowHelper.h"

#define DEFAULT_IMAGE_CONTENT_EDGE_SIZE 200
#define DEFAULT_IMAGE_NAME @"background.jpg"
#define PLACE_HOLDER_STRING @"Any Thing You Want to Say"

@implementation GenericContainerViewHelper

+ (NSString *) fontKey
{
    return @"FONT";
}

+ (NSString *) alignmentKey
{
    return @"ALIGNMENT";
}

+ (NSString *) rotationKey
{
    return @"ROTATION";
}

+ (NSString *) reflectionKey
{
    return @"REFLECTION";
}

+ (NSString *) shadowKey
{
    return @"SHADOW";
}

+ (NSString *) reflectionAlphaKey
{
    return @"REFLECTION_ALPHA";
}

+ (NSString *) reflectionSizeKey
{
    return @"REFLECTION_SIZE";
}

+ (NSString *) shadowAlphaKey
{
    return @"SHADOW_ALPHA";
}

+ (NSString *) shadowSizeKey
{
    return @"SHADOW_SIZE";
}

+ (NSString *) imageNameKey
{
    return @"IMAGE_NAME";
}

+ (NSString *) attibutedStringKey
{
    return @"ATTRIBUTED_STRING";
}

+ (NSMutableDictionary *) defaultContentAttributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[GenericContainerViewHelper shadowAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[GenericContainerViewHelper shadowSizeKey]];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[GenericContainerViewHelper reflectionAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[GenericContainerViewHelper reflectionSizeKey]];
    [attributes setValue:@(NO) forKey:[GenericContainerViewHelper reflectionKey]];
    [attributes setValue:@(NO) forKey:[GenericContainerViewHelper shadowKey]];
    return attributes;
}

+ (NSDictionary *) defaultImageAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:DEFAULT_IMAGE_NAME forKey:[GenericContainerViewHelper fontKey]];
    return [attributes copy];
}

+ (NSDictionary *) defaultTextAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:[TextFontHelper defaultFont] forKey:[GenericContainerViewHelper fontKey]];
    [attributes setObject:@(TextAlignmentLeft) forKey:[GenericContainerViewHelper alignmentKey]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:PLACE_HOLDER_STRING
                                                                           attributes:@{NSFontAttributeName : [TextFontHelper defaultFont],
                                                                                        NSParagraphStyleAttributeName : paragraphStyle}];
    [attributes setObject:attributedString forKey:[GenericContainerViewHelper attibutedStringKey]];
    return [attributes copy];
}

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes
{
    for (NSString *key in [changedAttributes allKeys]) {
        [fullAttributes setValue:changedAttributes[key] forKey:key];
    }
}
@end
