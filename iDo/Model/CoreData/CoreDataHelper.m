//
//  CoreDataHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CoreDataHelper.h"
#import "KeyConstants.h"
#import "GenericConent+iDo.h"
#import "TextContent+iDo.h"
#import "ImageContent+iDo.h"
#import "Proposal+iDo.h"    
#import <UIKit/UIKit.h>

#define ATTRIBUTES_KEY @"Attributes"
#define RANGES_KEY @"Ranges"

@implementation CoreDataHelper

+ (NSData *) encodeObject:(id<NSCopying>)object
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object];
    [archiver finishEncoding];
    return [data copy];
}

+ (NSObject *) decodeNSData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSObject *value = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    return value;
}

+ (NSData *) attributesDataFromAttributedString:(NSAttributedString *)attributedString
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSMutableArray *attributes = [NSMutableArray array];
    NSMutableArray *ranges = [NSMutableArray array];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        [attributes addObject:attrs];
        [ranges addObject:[NSValue valueWithRange:range]];
    }];
    [archiver encodeObject:attributes forKey:ATTRIBUTES_KEY];
    [archiver encodeObject:ranges forKey:RANGES_KEY];
    [archiver finishEncoding];
    
    return data;
}

+ (NSArray *) attributesFromData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    NSArray *attributes = [unarchiver decodeObjectForKey:ATTRIBUTES_KEY];
    [unarchiver finishDecoding];
    
    return attributes;
}

+ (NSArray *) rangesFromData:(NSData *) data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *ranges = [unarchiver decodeObjectForKey:RANGES_KEY];
    [unarchiver finishDecoding];
    return ranges;
}

+ (NSObject *) maxUniqueObjectForEntityName:(NSString *) entity inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    
    NSFetchRequest *maxUniqueRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    maxUniqueRequest.fetchLimit = 1;
    maxUniqueRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:NO]];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:maxUniqueRequest error:&error];
    if (error) {
        NSLog(@"Fetch Failed With Error: %@", error);
        assert(FALSE);
    } else if ([result count] > 1) {
        NSLog(@"Fetch Result More Than 1");
        assert(FALSE);
    } else if ([result count] == 0) {
        return nil;
    } else {
        return [result lastObject];
    }
}

+ (GenericConent *) contentFromAttributes:(NSDictionary *)attributes
                   inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    ContentViewType type = [attributes[[KeyConstants contentTypeKey]] unsignedIntegerValue];
    GenericConent *content = nil;
    switch (type) {
        case ContentViewTypeText:
            content = [TextContent textContentFromAttribute:attributes inManageObjectContext:managedObjectContext];
            break;
        case ContentViewTypeImage:
            content = [ImageContent imageContentFromAttribute:attributes inManageObjectContext:managedObjectContext];
        default:
            break;
    }
    return content;
}

+ (NSDictionary *) contentAttributesFromGenericContent:(GenericConent *)content
{
    if ([content isKindOfClass:[TextContent class]]) {
        return [TextContent attributesFromTextContent:(TextContent *)content];
    } else if ([content isKindOfClass:[ImageContent class]]) {
        return [ImageContent attributesFromImageContent:(ImageContent *) content];
    }
    return nil;
}

+ (NSArray *) loadAllProposalsFromManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Proposal"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES]];
    
    NSError *error = nil;
    NSArray *proposals = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        @throw [NSException exceptionWithName:@"Exception" reason:[error description] userInfo:nil];
    }
    return proposals;
}

+ (void) applyContentAttributes:(NSDictionary *)contentAttributes
                toContentObject:(GenericConent *)content
         inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    if ([content isKindOfClass:[TextContent class]]) {
        [TextContent applyTextAttribtues:contentAttributes toTextContent:(TextContent *)content inManageObjectContext:managedObjectContext];
    } else if ([content isKindOfClass:[ImageContent class]]) {
        [ImageContent applyImageAttributes:contentAttributes toImageContent:(ImageContent *)content inManagedObjectContext:managedObjectContext];
    }
}
@end
