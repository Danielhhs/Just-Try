//
//  TextContent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContent.h"
#import "TextContentDTO.h"
@interface TextContent (iDo)

+ (TextContent *) textContentFromAttribute:(TextContentDTO *) attributes
                     inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;


+ (TextContentDTO *) attributesFromTextContent:(TextContent *) content;

+ (void) applyTextAttribtues:(TextContentDTO *)textAttributes toTextContent:(TextContent *) textContent inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;
@end
