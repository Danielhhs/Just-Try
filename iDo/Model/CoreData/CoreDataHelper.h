//
//  CoreDataHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GenericContentDTO.h"
@class GenericConent;

@interface CoreDataHelper : NSObject

+ (NSData *) encodeObject:(id<NSCopying>) object;
+ (NSObject *) decodeNSData:(NSData *)data;

+ (NSData *) attributesDataFromAttributedString:(NSAttributedString *) attributedString;

+ (NSArray *) attributesFromData:(NSData *)data;

+ (NSArray *) rangesFromData:(NSData *) data;

+ (NSObject *) maxUniqueObjectForEntityName:(NSString *) entity
                     inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (GenericConent *) contentFromAttributes:(GenericContentDTO *) attributes
                   inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (GenericContentDTO *) contentAttributesFromGenericContent:(GenericConent *) content;

+ (NSArray *) loadAllProposalsFromManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void) applyContentAttributes:(GenericContentDTO *) contentAttributes toContentObject:(GenericConent *) content inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
;


@end
