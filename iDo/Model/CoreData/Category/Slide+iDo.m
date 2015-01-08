//
//  Slide+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Slide+iDo.h"
#import "CoreDataHelper.h"
#import "KeyConstants.h"
#import "GenericConent+iDo.h"
#import "CoreDataHelper.h"
#import "SlideAttributesManager.h"
#import <UIKit/UIKit.h>

@implementation Slide (iDo)

+ (Slide *) slideFromAttributes:(SlideDTO *)attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Slide *maxUnique = (Slide *)[CoreDataHelper maxUniqueObjectForEntityName:@"Slide" inManagedObjectContext:managedObjectContext];
    
    Slide *slide = [NSEntityDescription insertNewObjectForEntityForName:@"Slide" inManagedObjectContext:managedObjectContext];
    
    slide.unique = @([maxUnique.unique integerValue] + 1);
    
    [Slide applySlideAttributes:attributes toSlide:slide inManageObjectContext:managedObjectContext];
    return slide;
}

+ (SlideDTO *) attributesFromSlide:(Slide *)slide
{
    SlideDTO *attribtues = [[SlideDTO alloc] init];
    
    attribtues.backgroundImage = slide.background;
    
    NSSet *contents = slide.contents;
    NSArray *sortedContents = [contents sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    
    NSMutableArray *contentAttributes = [NSMutableArray array];
    for (GenericConent *content in sortedContents) {
        [contentAttributes addObject:[CoreDataHelper contentAttributesFromGenericContent:content]];
    }
    attribtues.contents = contentAttributes;
    attribtues.unique = [slide.unique integerValue];
    attribtues.thumbnail = [UIImage imageWithData:slide.thumbnail];
    attribtues.index = [slide.index integerValue];
    attribtues.currentAnimationIndex = [slide.currentAnimationIndex integerValue];
    return attribtues;
}

+ (void) applySlideAttributes:(SlideDTO *)slideAttributes toSlide:(Slide *)slide inManageObjectContext:(NSManagedObjectContext *)manageObjectContext
{
    slide.background = slideAttributes.backgroundImage;
    slide.thumbnail = UIImageJPEGRepresentation(slideAttributes.thumbnail, 1.f);
    slide.currentAnimationIndex = @(slideAttributes.currentAnimationIndex);
    NSArray *contentsAttributes = slideAttributes.contents;
    NSMutableSet *contents = [NSMutableSet set];
    for (NSInteger i = 0; i < [contentsAttributes count]; i++) {
        GenericConent *content = [[SlideAttributesManager sharedManager] genericContentFromAttributes:contentsAttributes[i] inManagedObjectContext:manageObjectContext];
        [contents addObject:content];
    }
    slide.contents = [contents copy];
}

@end
