//
//  Animation+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Animation.h"
#import "AnimationDTO.h"
@interface Animation (iDo)

+ (Animation *) animationFromAttributes:(AnimationDTO *) attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (AnimationDTO *) attributesFromAnimation:(Animation *) animation;
@end
