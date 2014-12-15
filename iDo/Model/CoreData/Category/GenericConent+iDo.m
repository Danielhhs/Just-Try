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
#import "Animation+iDo.h"

@implementation GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(NSDictionary *)attributes
                          inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    GenericConent *content = nil;
    content = [NSEntityDescription insertNewObjectForEntityForName:@"GenericContent" inManagedObjectContext:managedObjectContext];
    
    [GenericConent applyAttributes:attributes toGenericContent:content inManageObjectContext:managedObjectContext];
    
    return content;
}

+ (NSMutableDictionary *) attributesFromGenericContent:(GenericConent *)content
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[CoreDataHelper decodeNSData:content.center] forKey:[KeyConstants centerKey]];
    [attributes setValue:[CoreDataHelper decodeNSData:content.bounds] forKey:[KeyConstants boundsKey]];
    [attributes setValue:content.opacity forKey:[KeyConstants viewOpacityKey]];
    [attributes setValue:content.reflection forKey:[KeyConstants reflectionKey]];
    [attributes setValue:content.reflectionType forKey:[KeyConstants reflectionTypeKey]];
    [attributes setValue:content.reflectionAlpha forKey:[KeyConstants reflectionAlphaKey]];
    [attributes setValue:content.reflectionSize forKey:[KeyConstants reflectionSizeKey]];
    [attributes setValue:content.shadow forKey:[KeyConstants shadowKey]];
    [attributes setValue:content.shadowType forKey:[KeyConstants shadowTypeKey]];
    [attributes setValue:content.shadowAlpha forKey:[KeyConstants shadowAlphaKey]];
    [attributes setValue:content.shadowSize forKey:[KeyConstants shadowSizeKey]];
    [attributes setValue:content.rotation forKey:[KeyConstants rotationKey]];
    [attributes setValue:[CoreDataHelper decodeNSData:content.transform] forKey:[KeyConstants transformKey]];
    NSMutableArray *animations = [NSMutableArray array];
    for (Animation *animation in content.animations) {
        [animations addObject:[Animation attributesFromAnimation:animation]];
    }
    [attributes setValue:animations forKey:[KeyConstants animationsKey]];
    return attributes;
}


+ (void) applyAttributes:(NSDictionary *) attributes toGenericContent:(GenericConent *) content inManageObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    content.center = [CoreDataHelper encodeObject:attributes[[KeyConstants centerKey]]];
    content.bounds = [CoreDataHelper encodeObject:attributes[[KeyConstants boundsKey]]];
    content.opacity = attributes[[KeyConstants viewOpacityKey]];
    content.reflection = attributes[[KeyConstants reflectionKey]];
    content.reflectionType = attributes[[KeyConstants reflectionTypeKey]];
    content.reflectionAlpha = attributes[[KeyConstants reflectionAlphaKey]];
    content.reflectionSize = attributes[[KeyConstants reflectionSizeKey]];
    content.shadow = attributes[[KeyConstants shadowKey]];
    content.shadowType = attributes[[KeyConstants shadowTypeKey]];
    content.shadowAlpha = attributes[[KeyConstants shadowAlphaKey]];
    content.shadowSize = attributes[[KeyConstants shadowSizeKey]];
    content.rotation = attributes[[KeyConstants rotationKey]];
    content.transform = [CoreDataHelper encodeObject:attributes[[KeyConstants transformKey]]];
    NSMutableSet *animations = [NSMutableSet set];
    NSArray *animationArray = attributes[[KeyConstants animationsKey]];
    for (NSDictionary *animationAttributes in animationArray) {
        Animation *animation = [Animation animationFromAttributes:animationAttributes inManagedObjectContext:manageObjectContext];
        [animations addObject:animation];
    }
    content.animations = animations;
}
@end
