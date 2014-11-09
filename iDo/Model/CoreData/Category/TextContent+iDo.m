//
//  TextContent+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContent+iDo.h"
#import "GenericConent+iDo.h"
#import "KeyConstants.h"
#import "CoreDataHelper.h"

@implementation TextContent (iDo)

+ (TextContent *) textContentFromAttribute:(NSDictionary *)attributes inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    TextContent *textContent = [NSEntityDescription insertNewObjectForEntityForName:@"TextContent" inManagedObjectContext:managedObjectContext];
    
    [TextContent applyTextAttribtues:attributes toTextContent:textContent inManageObjectContext:managedObjectContext];
    
    return textContent;
}

+ (NSDictionary *) attributesFromTextContent:(TextContent *)content
{
    NSMutableDictionary *attributes = [[GenericConent attributesFromGenericContent:content] mutableCopy];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content.text];
    
    NSArray *stringAttributes = [CoreDataHelper attributesFromData:content.attributes];
    NSArray *ranges = [CoreDataHelper rangesFromData:content.attributes];
    
    for (NSUInteger i = 0; i < [stringAttributes count]; i++) {
        [attributedString addAttributes:stringAttributes[i] range:[ranges[i] rangeValue]];
    }
    [attributes setValue:content.contentType forKey:[KeyConstants contentTypeKey]];
    [attributes setValue:[attributedString copy] forKey:[KeyConstants attibutedStringKey]];
    
    return [attributes copy];;
}

+ (void) applyTextAttribtues:(NSDictionary *)textAttributes toTextContent:(TextContent *)textContent inManageObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    [GenericConent applyAttributes:textAttributes toGenericContent:textContent inManageObjectContext:manageObjectContext];
    textContent.contentType = @(ContentViewTypeText);
    NSAttributedString *attributedString = textAttributes[[KeyConstants attibutedStringKey]];
    textContent.text = attributedString.string;
    textContent.attributes = [CoreDataHelper attributesDataFromAttributedString:attributedString];
}

@end
