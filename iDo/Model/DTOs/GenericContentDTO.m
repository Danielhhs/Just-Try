//
//  GenericContentDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "GenericContentDTO.h"
#import "DrawingConstants.h"
@implementation GenericContentDTO

+ (void) applyDefaultGenericContentToContentDTO:(GenericContentDTO *)content
{
    content.opacity = 1;
    content.reflection = NO;
    content.shadow = NO;
    content.reflectionAlpha = [DrawingConstants goldenRatio];
    content.reflectionSize = [DrawingConstants counterGoldenRatio];
    content.shadowType = ContentViewShadowTypeNone;
    content.shadowAlpha = [DrawingConstants goldenRatio];
    content.shadowSize = [DrawingConstants counterGoldenRatio];
    content.transform = CGAffineTransformIdentity;
    content.uuid = [NSUUID UUID];
    content.animations = [NSMutableArray array];
}

@end
