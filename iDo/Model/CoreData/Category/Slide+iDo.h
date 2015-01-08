//
//  Slide+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/7/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Slide.h"
#import "SlideDTO.h"

@interface Slide (iDo)

+ (Slide *) slideFromAttributes:(SlideDTO *) attributes
         inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (SlideDTO *) attributesFromSlide:(Slide *) slide;
+ (void) applySlideAttributes:(SlideDTO *) slideAttributes toSlide:(Slide *) slide inManageObjectContext:(NSManagedObjectContext *) manageObjectContext;
@end
