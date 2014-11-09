//
//  CoreDataHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GenericConent;

@interface CoreDataHelper : NSObject

+ (NSData *) encodeObject:(id<NSCopying>) object;
+ (NSObject *) decodeNSData:(NSData *)data;

+ (NSData *) attributesDataFromAttributedString:(NSAttributedString *) attributedString;

+ (NSArray *) attributesFromData:(NSData *)data;

+ (NSArray *) rangesFromData:(NSData *) data;

+ (NSObject *) maxUniqueObjectForEntityName:(NSString *) entity
                     inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (GenericConent *) contentFromAttributes:(NSDictionary *) attributes
                   inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (NSDictionary *) contentAttributesFromGenericContent:(GenericConent *) content;

+ (NSArray *) loadAllProposalsFromManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void) applyContentAttributes:(NSDictionary *) contentAttributes toContentObject:(GenericConent *) content inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
;


@end
