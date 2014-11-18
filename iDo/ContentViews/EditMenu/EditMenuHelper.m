//
//  EditMenuHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/18/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuHelper.h"
static NSMutableArray *keys;
@implementation EditMenuHelper

+ (NSData *) encodeGenericContent:(GenericContainerView *)content
{
    NSDictionary *attributes = [content attributes];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
#warning Need to Change this
    keys = [NSMutableArray array];
    
    for (NSString *key in [attributes allKeys]) {
        [keys addObject:key];
        [archiver encodeObject:attributes[key] forKey:key];
    }
    [archiver finishEncoding];
    
    return [data copy];;
}

+ (NSMutableDictionary *) decodeGenericContentFromData:(NSData *)data
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    for (NSString *key in keys) {
        [attributes setObject:[unarchiver decodeObjectForKey:key] forKey:key];
    }
    [unarchiver finishDecoding];
    return attributes;
}

@end
