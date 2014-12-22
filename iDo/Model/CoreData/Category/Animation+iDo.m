//
//  Animation+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Animation+iDo.h"
#import "KeyConstants.h"
#import "GenericConent.h"
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
    attributes[[KeyConstants animationEffectKey]] = animation.effect;
    attributes[[KeyConstants animationTriggerTimeKey]] = animation.triggerTime;
    attributes[[KeyConstants animationIndexKey]] = animation.index;
    attributes[[KeyConstants animationDirectionKey]] = animation.direction;
    attributes[[KeyConstants animationEventKey]] = animation.event;
    attributes[[KeyConstants contentUUIDKey]] = [[NSUUID alloc] initWithUUIDString:animation.container.uuid];
    return attributes;
}

+ (void) applyAnimationAttributes:(NSDictionary *) attributes toAnimation:(Animation *) animation
{
    animation.duration = attributes[[KeyConstants animationDurationKey]];
    animation.effect = attributes[[KeyConstants animationEffectKey]];
    animation.event = attributes[[KeyConstants animationEventKey]];
    animation.triggerTime = attributes[[KeyConstants animationTriggerTimeKey]];
    animation.index = attributes[[KeyConstants animationIndexKey]];
    animation.direction = attributes[[KeyConstants animationDirectionKey]];
}
@end
