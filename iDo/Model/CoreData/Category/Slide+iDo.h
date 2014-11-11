//
//  Slide+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Slide.h"

@interface Slide (iDo)

+ (Slide *) slideFromAttributes:(NSDictionary *) attributes
         inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (NSMutableDictionary *) attributesFromSlide:(Slide *) slide;
+ (void) applySlideAttributes:(NSDictionary *) slideAttributes toSlide:(Slide *) slide inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;
@end
