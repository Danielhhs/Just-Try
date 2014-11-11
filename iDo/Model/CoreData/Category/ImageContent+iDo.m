//
//  ImageContent+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageContent+iDo.h"
#import "GenericConent+iDo.h"
#import "KeyConstants.h"

@implementation ImageContent (iDo)

+ (ImageContent *) imageContentFromAttribute:(NSDictionary *)attributes
                       inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    ImageContent *imageContent = [NSEntityDescription insertNewObjectForEntityForName:@"ImageContent" inManagedObjectContext:managedObjectContext];
    
    [ImageContent applyImageAttributes:attributes toImageContent:imageContent inManagedObjectContext:managedObjectContext];
    
    return imageContent;
}

+ (NSMutableDictionary *) attributesFromImageContent:(ImageContent *)content
{
    NSMutableDictionary *attributes = [[GenericConent attributesFromGenericContent:content] mutableCopy];
    
    [attributes setValue:content.imageName forKey:[KeyConstants imageNameKey]];
    [attributes setValue:content.filter forKey:[KeyConstants filterKey]];
    [attributes setValue:content.contentType forKey:[KeyConstants contentTypeKey]];
    
    return attributes;
}


+ (void) applyImageAttributes:(NSDictionary *)imageAttribtues toImageContent:(ImageContent *)imageContent inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [GenericConent applyAttributes:imageAttribtues toGenericContent:imageContent inManageObjectContext:managedObjectContext];
    
    imageContent.imageName = imageAttribtues[[KeyConstants imageNameKey]];
    imageContent.filter = imageAttribtues[[KeyConstants filterKey]];
    imageContent.contentType = @(ContentViewTypeImage);
}
@end
