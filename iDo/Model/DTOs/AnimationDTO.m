//
//  AnimationDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "AnimationDTO.h"
#import "KeyConstants.h"

@implementation AnimationDTO

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.duration forKey:[KeyConstants animationDurationKey]];
    [aCoder encodeInteger:self.effect forKey:[KeyConstants animationEffectKey]];
    [aCoder encodeDouble:self.triggeredTime forKey:[KeyConstants animationTriggerTimeKey]];
    [aCoder encodeInteger:self.index forKey:[KeyConstants animationIndexKey]];
    [aCoder encodeInteger:self.direction forKey:[KeyConstants animationDirectionKey]];
    [aCoder encodeInteger:self.event forKey:[KeyConstants animationEventKey]];
    [aCoder encodeObject:self.contentUUID forKey:[KeyConstants contentUUIDKey]];
}

@end
