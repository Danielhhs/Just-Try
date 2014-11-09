//
//  GenericConent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericConent.h"


typedef NS_ENUM(NSUInteger, ContentViewType) {
    ContentViewTypeImage = 0,
    ContentViewTypeText = 1,
    ContentViewTypeVideo = 2
};

@interface GenericConent (iDo)

+ (GenericConent *) genericContentFromAttribute:(NSDictionary *) attributes
                          inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (NSDictionary *) attributesFromGenericContent:(GenericConent *) content;

+ (void) applyAttributes:(NSDictionary *) attributes toGenericContent:(GenericConent *) content inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;

@end
