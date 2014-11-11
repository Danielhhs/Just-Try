//
//  ImageContent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageContent.h"

@interface ImageContent (iDo)

+ (ImageContent *) imageContentFromAttribute:(NSDictionary *) attributes
                       inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;


+ (NSMutableDictionary *) attributesFromImageContent:(ImageContent *) content;

+ (void) applyImageAttributes:(NSDictionary *) imageAttribtues toImageContent:(ImageContent *) imageContent inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;
@end
