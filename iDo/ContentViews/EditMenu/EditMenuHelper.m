//
//  EditMenuHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/18/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuHelper.h"
#import "KeyConstants.h"
#import "TextContentDTO.h"
#import "ImageContentDTO.h"

@implementation EditMenuHelper

+ (NSData *) encodeGenericContent:(GenericContainerView *)content
{
    GenericContentDTO *attributes = [content attributes];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeCGPoint:attributes.center forKey:[KeyConstants centerKey]];
    [archiver encodeCGRect:attributes.bounds forKey:[KeyConstants boundsKey]];
    [archiver encodeDouble:attributes.opacity forKey:[KeyConstants viewOpacityKey]];
    [archiver encodeBool:attributes.reflection forKey:[KeyConstants reflectionKey]];
    [archiver encodeBool:attributes.shadow forKey:[KeyConstants shadowKey]];
    [archiver encodeDouble:attributes.reflectionAlpha forKey:[KeyConstants reflectionAlphaKey]];
    [archiver encodeDouble:attributes.reflectionSize forKey:[KeyConstants reflectionSizeKey]];
    [archiver encodeInteger:attributes.shadowType forKey:[KeyConstants shadowTypeKey]];
    [archiver encodeDouble:attributes.shadowAlpha forKey:[KeyConstants shadowAlphaKey]];
    [archiver encodeDouble:attributes.shadowSize forKey:[KeyConstants shadowSizeKey]];
    [archiver encodeCGAffineTransform:attributes.transform forKey:[KeyConstants transformKey]];
    [archiver encodeObject:[attributes.uuid UUIDString] forKey:[KeyConstants contentUUIDKey]];
    [archiver encodeObject:attributes.animations forKey:[KeyConstants animationsKey]];
    [archiver encodeInteger:attributes.contentType forKey:[KeyConstants contentTypeKey]];
    
    if ([attributes isKindOfClass:[TextContentDTO class]]) {
        TextContentDTO *textContent = (TextContentDTO *)attributes;
        [archiver encodeObject:textContent.attributedString forKey:[KeyConstants attibutedStringKey]];
        [archiver encodeObject:textContent.backgroundColor forKey:[KeyConstants textBackgroundColorKey]];
    } else if ([attributes isKindOfClass:[ImageContentDTO class]]) {
        ImageContentDTO *imageContent = (ImageContentDTO *)attributes;
        [archiver encodeObject:imageContent.imageName forKey:[KeyConstants imageNameKey]];
    }
    
    [archiver finishEncoding];
    
    return [data copy];
}

+ (GenericContentDTO *) decodeGenericContentFromData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    ContentViewType contentType = [unarchiver decodeIntegerForKey:[KeyConstants contentTypeKey]];
    GenericContentDTO *content;
    if (contentType == ContentViewTypeImage) {
        content = [[ImageContentDTO alloc] init];
    } else if (contentType == ContentViewTypeText) {
        content = [[TextContentDTO alloc] init];
    }
    
    content.center = [unarchiver decodeCGPointForKey:[KeyConstants centerKey]];
    content.bounds = [unarchiver decodeCGRectForKey:[KeyConstants boundsKey]];
    content.opacity = [unarchiver decodeDoubleForKey:[KeyConstants viewOpacityKey]];
    content.reflection = [unarchiver decodeBoolForKey:[KeyConstants reflectionKey]];
    content.shadow = [unarchiver decodeBoolForKey:[KeyConstants shadowKey]];
    content.reflectionAlpha = [unarchiver decodeDoubleForKey:[KeyConstants reflectionAlphaKey]];
    content.reflectionSize = [unarchiver decodeDoubleForKey:[KeyConstants reflectionSizeKey]];
    content.shadowType = [unarchiver decodeIntegerForKey:[KeyConstants shadowTypeKey]];
    content.shadowAlpha = [unarchiver decodeDoubleForKey:[KeyConstants shadowAlphaKey]];
    content.shadowSize = [unarchiver decodeDoubleForKey:[KeyConstants shadowSizeKey]];
    content.transform = [unarchiver decodeCGAffineTransformForKey:[KeyConstants transformKey]];
    content.uuid = [NSUUID UUID];
    content.animations = [unarchiver decodeObjectForKey:[KeyConstants animationsKey]];
    content.contentType = contentType;
    
    if ([content isKindOfClass:[TextContentDTO class]]) {
        TextContentDTO *textContent = (TextContentDTO *)content;
        textContent.attributedString = [unarchiver decodeObjectForKey:[KeyConstants attibutedStringKey]];
        textContent.backgroundColor = [unarchiver decodeObjectForKey:[KeyConstants textBackgroundColorKey]];
    } else if ([content isKindOfClass:[ImageContentDTO class]]) {
        ImageContentDTO *imageContent = (ImageContentDTO *)content;
        imageContent.imageName = [unarchiver decodeObjectForKey:[KeyConstants imageNameKey]];
    }
    
    [unarchiver finishDecoding];
    return content;
}

@end
