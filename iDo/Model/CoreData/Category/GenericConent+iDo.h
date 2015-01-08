//
//  GenericConent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericConent.h"
#import "GenericContentDTO.h"

@interface GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(GenericContentDTO *) attributes
                          inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (void) applyContent:(GenericConent *) content toAttributes:(GenericContentDTO *)attributes;

+ (void) applyAttributes:(GenericContentDTO *) attributes toGenericContent:(GenericConent *) content inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;

@end
