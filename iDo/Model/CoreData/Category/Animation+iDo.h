//
//  Animation+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Animation.h"

@interface Animation (iDo)

+ (Animation *) animationFromAttributes:(NSDictionary *) attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSMutableDictionary *) attributesFromAnimation:(Animation *) animation;
@end
