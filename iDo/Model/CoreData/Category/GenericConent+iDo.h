//
//  GenericConent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericConent.h"
#import "GenericContentConstants.h"

@interface GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(NSDictionary *) attributes
                          inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (NSMutableDictionary *) attributesFromGenericContent:(GenericConent *) content;

+ (void) applyAttributes:(NSDictionary *) attributes toGenericContent:(GenericConent *) content inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;

@end
