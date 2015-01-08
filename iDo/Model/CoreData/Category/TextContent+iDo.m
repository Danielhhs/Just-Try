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

+ (TextContent *) textContentFromAttribute:(TextContentDTO *)attributes inManageObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    TextContent *textContent = [NSEntityDescription insertNewObjectForEntityForName:@"TextContent" inManagedObjectContext:managedObjectContext];
    
    [TextContent applyTextAttribtues:attributes toTextContent:textContent inManageObjectContext:managedObjectContext];
    
    return textContent;
}

+ (TextContentDTO *) attributesFromTextContent:(TextContent *)content
{
    TextContentDTO *attributes = [[TextContentDTO alloc] init];
    [GenericConent applyContent:content toAttributes:attributes];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content.text];
    
    NSArray *stringAttributes = [CoreDataHelper attributesFromData:content.attributes];
    NSArray *ranges = [CoreDataHelper rangesFromData:content.attributes];
    
    for (NSUInteger i = 0; i < [stringAttributes count]; i++) {
        [attributedString addAttributes:stringAttributes[i] range:[ranges[i] rangeValue]];
    }
    attributes.contentType = [content.contentType integerValue];
    attributes.attributedString = attributedString;
    CGFloat red = [content.backgoundR doubleValue];
    CGFloat green = [content.backgoundG doubleValue];
    CGFloat blue = [content.backgroundB doubleValue];
    CGFloat alpha = [content.backgroundA doubleValue];
    attributes.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return attributes;
}

+ (void) applyTextAttribtues:(TextContentDTO *)textAttributes toTextContent:(TextContent *)textContent inManageObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    [GenericConent applyAttributes:textAttributes toGenericContent:textContent inManageObjectContext:manageObjectContext];
    textContent.contentType = @(ContentViewTypeText);
    NSAttributedString *attributedString = textAttributes.attributedString;
    textContent.text = attributedString.string;
    textContent.attributes = [CoreDataHelper attributesDataFromAttributedString:attributedString];
    CGFloat red, blue, green, alpha;
    [textAttributes.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    textContent.backgoundR = @(red);
    textContent.backgoundG = @(green);
    textContent.backgroundB = @(blue);
    textContent.backgroundA = @(alpha);
}

@end
