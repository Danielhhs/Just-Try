//
//  Animation+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Animation+iDo.h"
#import "GenericConent.h"
#import "AnimationDTO.h"
@implementation Animation (iDo)

+ (Animation *) animationFromAttributes:(AnimationDTO *)attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Animation *animation = [NSEntityDescription insertNewObjectForEntityForName:@"Animation" inManagedObjectContext:managedObjectContext];
    
    [Animation applyAnimationAttributes:attributes toAnimation:animation];
    
    return animation;
}

+ (AnimationDTO *) attributesFromAnimation:(Animation *) animation
{
    AnimationDTO *attributes = [[AnimationDTO alloc] init];
    
    attributes.duration= [animation.duration doubleValue];
    attributes.effect = [animation.effect doubleValue];
    attributes.triggeredTime = [animation.triggerTime doubleValue];
    attributes.index = [animation.index integerValue];
    attributes.direction = [animation.direction integerValue];
    attributes.event = [animation.event integerValue];
    attributes.contentUUID = [[NSUUID alloc] initWithUUIDString:animation.container.uuid];
    return attributes;
}

+ (void) applyAnimationAttributes:(AnimationDTO *) attributes toAnimation:(Animation *) animation
{
    animation.duration = @(attributes.duration);
    animation.effect = @(attributes.effect);
    animation.event = @(attributes.event);
    animation.triggerTime = @(attributes.triggeredTime);
    animation.index = @(attributes.index);
    animation.direction = @(attributes.direction);
}
@end
