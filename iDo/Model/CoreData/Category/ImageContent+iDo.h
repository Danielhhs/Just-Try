//
//  ImageContent+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageContent.h"
#import "ImageContentDTO.h"

@interface ImageContent (iDo)

+ (ImageContent *) imageContentFromAttribute:(ImageContentDTO *) attributes
                       inManageObjectContext:(NSManagedObjectContext *) managedObjectContext;


+ (ImageContentDTO *) attributesFromImageContent:(ImageContent *) content;

+ (void) applyImageAttributes:(ImageContentDTO *) imageAttribtues toImageContent:(ImageContent *) imageContent inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;
@end
