//
//  GenericConent+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericConent+iDo.h"
#import "CoreDataHelper.h"
#import "Animation+iDo.h"
#import "AnimationDTO.h"

@implementation GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(GenericContentDTO *)attributes
                          inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    GenericConent *content = nil;
    content = [NSEntityDescription insertNewObjectForEntityForName:@"GenericContent" inManagedObjectContext:managedObjectContext];
    
    [GenericConent applyAttributes:attributes toGenericContent:content inManageObjectContext:managedObjectContext];
    
    return content;
}

+ (void) applyContent:(GenericConent *)content toAttributes:(GenericContentDTO *)attributes
{
    attributes.center = [((NSValue *)[CoreDataHelper decodeNSData:content.center]) CGPointValue];
    attributes.bounds = [((NSValue *)[CoreDataHelper decodeNSData:content.bounds]) CGRectValue];
    attributes.transform = [((NSValue *)[CoreDataHelper decodeNSData:content.transform]) CGAffineTransformValue];
    attributes.opacity = [content.opacity doubleValue];
    attributes.reflection = [content.reflection boolValue];
    attributes.reflectionAlpha = [content.reflectionAlpha doubleValue];
    attributes.reflectionSize = [content.reflectionSize doubleValue];
    attributes.shadow = [content.shadow boolValue];
    attributes.shadowType = [content.shadowType integerValue];
    attributes.shadowAlpha = [content.shadowAlpha doubleValue];
    attributes.shadowSize = [content.shadowSize doubleValue];
    attributes.uuid = [[NSUUID alloc] initWithUUIDString:content.uuid];
    NSMutableArray *animations = [NSMutableArray array];
    for (Animation *animation in content.animations) {
        [animations addObject:[Animation attributesFromAnimation:animation]];
    }
    attributes.animations = animations;
}


+ (void) applyAttributes:(GenericContentDTO *) attributes toGenericContent:(GenericConent *) content inManageObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    content.center = [CoreDataHelper encodeObject:[NSValue valueWithCGPoint:attributes.center]];
    content.bounds = [CoreDataHelper encodeObject:[NSValue valueWithCGRect:attributes.bounds]];
    content.opacity = @(attributes.opacity);
    content.reflection = @(attributes.reflection);
    content.reflectionAlpha = @(attributes.reflectionAlpha);
    content.reflectionSize = @(attributes.reflectionSize);
    content.shadow = @(attributes.shadow);
    content.shadowType = @(attributes.shadowType);
    content.shadowAlpha = @(attributes.shadowAlpha);
    content.shadowSize = @(attributes.shadowSize);
    content.transform = [CoreDataHelper encodeObject:[NSValue valueWithCGAffineTransform:attributes.transform]];
    content.uuid = [attributes.uuid UUIDString];
    NSMutableSet *animations = [NSMutableSet set];
    NSArray *animationArray = attributes.animations;
    for (AnimationDTO *animationAttributes in animationArray) {
        Animation *animation = [Animation animationFromAttributes:animationAttributes inManagedObjectContext:manageObjectContext];
        [animations addObject:animation];
    }
    content.animations = animations;
}
@end
