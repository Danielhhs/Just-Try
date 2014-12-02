//
//  DefaultValueGenerator.m
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "DefaultValueGenerator.h"
#import "KeyConstants.h"
#import <UIKit/UIKit.h>
#import "TextFontHelper.h"
#import "ControlPointManager.h"
#import "DrawingConstants.h"
#import "GenericContentConstants.h"
#import "ShadowHelper.h"
#import "ReflectionHelper.h"

#define DEFAULT_BACKGROUND_IMAGE @"Canvas.png"
#define DEFAULT_PROPOSAL_NAME @"New"

#define DEFAULT_IMAGE_EDGE 300

#define DEFAULT_TEXT_CONTAINER_WIDTH 300.f
#define DEFAULT_TEXT_CONTAINER_HEIGHT 30
#define DEFAULT_IMAGE_NAME @"background.jpg"
#define PLACE_HOLDER_STRING @"Any Thing You Want to Say"

@implementation DefaultValueGenerator

+ (NSMutableDictionary *) defaultProposalAttributes
{
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    
    [attribute setValue:DEFAULT_PROPOSAL_NAME forKey:[KeyConstants proposalNameKey]];
    [attribute setValue:[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE] forKey:[KeyConstants proposalThumbnailKey]];
    [attribute setValue:@(0) forKey:[KeyConstants proposalCurrentSelectedSlideKey]];
    [attribute setValue:@[[DefaultValueGenerator defaultSlideAttributes]] forKey:[KeyConstants proposalSlidesKey]];
    
    return attribute;
}

+ (NSMutableDictionary *) defaultSlideAttributes
{
    NSMutableDictionary *attribtues = [NSMutableDictionary dictionary];
    
    [attribtues setValue:DEFAULT_BACKGROUND_IMAGE forKey:[KeyConstants slideBackgroundKey]];
    [attribtues setValue:[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE] forKey:[KeyConstants slideThumbnailKey]];
    
    return attribtues;
}

+ (NSMutableDictionary *) defaultContentAttributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@([DrawingConstants goldenRatio]) forKey:[KeyConstants shadowAlphaKey]];
    [attributes setValue:@([DrawingConstants counterGoldenRatio]) forKey:[KeyConstants shadowSizeKey]];
    [attributes setValue:@([DrawingConstants goldenRatio]) forKey:[KeyConstants reflectionAlphaKey]];
    [attributes setValue:@([DrawingConstants counterGoldenRatio]) forKey:[KeyConstants reflectionSizeKey]];
    [attributes setValue:@(NO) forKey:[KeyConstants reflectionKey]];
    [attributes setValue:@(NO) forKey:[KeyConstants shadowKey]];
    [attributes setValue:@(ContentViewShadowTypeNone) forKey:[KeyConstants shadowTypeKey]];
    [attributes setValue:@(ContentViewReflectionTypeVerticalMirror) forKey:[KeyConstants reflectionTypeKey]];
    [attributes setValue:@(1) forKey:[KeyConstants viewOpacityKey]];
    [attributes setObject:[NSValue valueWithCGAffineTransform:CGAffineTransformIdentity] forKey:[KeyConstants transformKey]];
    return attributes;
}

+ (NSMutableDictionary *) defaultImageAttributes
{
    NSMutableDictionary *attributes = [DefaultValueGenerator defaultContentAttributes];
    [attributes setObject:DEFAULT_IMAGE_NAME forKey:[KeyConstants imageNameKey]];
    UIImage *image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    CGFloat scale = image.size.width / image.size.height;
    CGFloat width = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGFloat height = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGRect bounds = CGRectMake(0, 0, width, height);
    [attributes setObject:[NSValue valueWithCGRect:bounds] forKey:[KeyConstants boundsKey]];
    [attributes setObject:[NSValue valueWithCGPoint:CGPointMake(200, 300)] forKey:[KeyConstants centerKey]];
    [attributes setObject:@(ContentViewTypeImage) forKey:[KeyConstants contentTypeKey]];
    return attributes;
}

+ (NSMutableDictionary *) defaultTextAttributes
{
    NSMutableDictionary *attributes = [DefaultValueGenerator defaultContentAttributes];
    [attributes setObject:[TextFontHelper defaultFont] forKey:[KeyConstants fontKey]];
    [attributes setObject:@(TextAlignmentLeft) forKey:[KeyConstants alignmentKey]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:PLACE_HOLDER_STRING
                                                                           attributes:@{NSFontAttributeName : [TextFontHelper defaultFont],
                                                                                        NSParagraphStyleAttributeName : paragraphStyle}];
    [attributes setObject:attributedString forKey:[KeyConstants attibutedStringKey]];
    NSValue *boundsValue = [NSValue valueWithCGRect:CGRectMake(0, 0, DEFAULT_TEXT_CONTAINER_WIDTH, 2 * [DrawingConstants controlPointSizeHalf] + DEFAULT_TEXT_CONTAINER_HEIGHT)];
    [attributes setObject:boundsValue forKey:[KeyConstants boundsKey]];
    [attributes setObject:[UIColor whiteColor] forKey:[KeyConstants textColorKey]];
    [attributes setObject:[UIColor clearColor] forKey:[KeyConstants textBackgroundColorKey]];
    [attributes setObject:[NSValue valueWithCGPoint:CGPointMake(200, 300)] forKey:[KeyConstants centerKey]];
    [attributes setObject:@(ContentViewTypeText) forKey:[KeyConstants contentTypeKey]];
    return attributes;
}
@end
