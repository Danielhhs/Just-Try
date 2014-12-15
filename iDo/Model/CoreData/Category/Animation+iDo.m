//
//  Animation+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Animation+iDo.h"
#import "KeyConstants.h"
@implementation Animation (iDo)

+ (Animation *) animationFromAttributes:(NSDictionary *)attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Animation *animation = [NSEntityDescription insertNewObjectForEntityForName:@"Animation" inManagedObjectContext:managedObjectContext];
    
    [Animation applyAnimationAttributes:attributes toAnimation:animation];
    
    return animation;
}

+ (NSMutableDictionary *) attributesFromAnimation:(Animation *) animation
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[[KeyConstants animationDurationKey]] = animation.duration;
    attributes[[KeyConstants animationTypeKey]] = animation.type;
    attributes[[KeyConstants animationTriggerTimeKey]] = animation.triggerTime;
    attributes[[KeyConstants animationIndexKey]] = animation.index;
    
    return attributes;
}

+ (void) applyAnimationAttributes:(NSDictionary *) attributes toAnimation:(Animation *) animation
{
    animation.duration = attributes[[KeyConstants animationDurationKey]];
    animation.type = attributes[[KeyConstants animationTypeKey]];
    animation.triggerTime = attributes[[KeyConstants animationTriggerTimeKey]];
    animation.index = attributes[[KeyConstants animationIndexKey]];
}
@end
