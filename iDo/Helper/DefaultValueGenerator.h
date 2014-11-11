//
//  DefaultValueGenerator.h
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultValueGenerator : NSObject

+ (NSMutableDictionary *) defaultProposalAttributes;
+ (NSMutableDictionary *) defaultSlideAttributes;
+ (NSMutableDictionary *) defaultTextAttributes;
+ (NSMutableDictionary *) defaultImageAttributes;
@end
