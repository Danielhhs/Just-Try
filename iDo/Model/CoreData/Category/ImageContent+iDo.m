//
//  ImageContent+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageContent+iDo.h"
#import "GenericConent+iDo.h"

@implementation ImageContent (iDo)

+ (ImageContent *) imageContentFromAttribute:(ImageContentDTO *)attributes
                       inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    ImageContent *imageContent = [NSEntityDescription insertNewObjectForEntityForName:@"ImageContent" inManagedObjectContext:managedObjectContext];
    
    [ImageContent applyImageAttributes:attributes toImageContent:imageContent inManagedObjectContext:managedObjectContext];
    
    return imageContent;
}

+ (ImageContentDTO *) attributesFromImageContent:(ImageContent *)content
{
    ImageContentDTO *attributes = [[ImageContentDTO alloc] init];
    
    [GenericConent applyContent:content toAttributes:attributes];
    attributes.imageName = content.imageName;
    attributes.contentType = [content.contentType integerValue];
    
    return attributes;
}


+ (void) applyImageAttributes:(ImageContentDTO *)imageAttribtues toImageContent:(ImageContent *)imageContent inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [GenericConent applyAttributes:imageAttribtues toGenericContent:imageContent inManageObjectContext:managedObjectContext];
    
    imageContent.imageName = imageAttribtues.imageName;
    imageContent.contentType = @(ContentViewTypeImage);
}
@end
