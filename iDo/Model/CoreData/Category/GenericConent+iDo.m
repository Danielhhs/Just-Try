//
//  GenericConent+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericConent+iDo.h"
#import "KeyConstants.h"
#import "CoreDataHelper.h"

@implementation GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(NSDictionary *)attributes
                          inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    GenericConent *content = nil;
    
    content = [NSEntityDescription insertNewObjectForEntityForName:@"GenericContent" inManagedObjectContext:managedObjectContext];
    content.center = [CoreDataHelper encodeNSValue:attributes[[KeyConstants centerKey]]];
    content.frame = [CoreDataHelper encodeNSValue:attributes[[KeyConstants frameKey]]];
    content.opacity = attributes[[KeyConstants viewOpacityKey]];
    content.reflection = attributes[[KeyConstants reflectionKey]];
    content.reflectionAlpha = attributes[[KeyConstants reflectionAlphaKey]];
    content.reflectionSize = attributes[[KeyConstants reflectionSizeKey]];
    content.shadow = attributes[[KeyConstants shadowKey]];
    content.shadowAlpha = attributes[[KeyConstants shadowAlphaKey]];
    content.shadowSize = attributes[[KeyConstants shadowSizeKey]];
    content.rotation = attributes[[KeyConstants rotationKey]];
    content.transform = [CoreDataHelper encodeNSValue:attributes[[KeyConstants transformKey]]];
    
    return content;
}

+ (NSDictionary *) attributesFromGenericContent:(GenericConent *)content
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[CoreDataHelper decodeNSData:content.center] forKey:[KeyConstants centerKey]];
    [attributes setValue:[CoreDataHelper decodeNSData:content.frame] forKey:[KeyConstants frameKey]];
    [attributes setValue:content.opacity forKey:[KeyConstants viewOpacityKey]];
    [attributes setValue:content.reflection forKey:[KeyConstants reflectionKey]];
    [attributes setValue:content.reflectionAlpha forKey:[KeyConstants reflectionAlphaKey]];
    [attributes setValue:content.reflectionSize forKey:[KeyConstants reflectionSizeKey]];
    [attributes setValue:content.shadow forKey:[KeyConstants shadowKey]];
    [attributes setValue:content.shadowAlpha forKey:[KeyConstants shadowAlphaKey]];
    [attributes setValue:content.shadowSize forKey:[KeyConstants shadowSizeKey]];
    [attributes setValue:content.rotation forKey:[KeyConstants rotationKey]];
    [attributes setValue:[CoreDataHelper decodeNSData:content.transform] forKey:[KeyConstants transformKey]];
    
    return attributes;
}

@end
