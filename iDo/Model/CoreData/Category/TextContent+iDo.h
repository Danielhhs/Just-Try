//
//  TextContent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContent.h"

@interface TextContent (iDo)

+ (TextContent *) textContentFromAttribute:(NSDictionary *) attributes
                     inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;


+ (NSDictionary *) attributesFromTextContent:(TextContent *) content;

+ (void) applyTextAttribtues:(NSDictionary *)textAttributes toTextContent:(TextContent *) textContent inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;
@end
