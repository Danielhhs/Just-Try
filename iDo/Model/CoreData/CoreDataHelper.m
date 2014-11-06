//
//  CoreDataHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper


+ (NSData *) encodeNSValue:(NSValue *)value
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:value];
    return [data copy];
}

+ (NSValue *) decodeNSData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSValue *value = [unarchiver decodeObject];
    return value;
}
@end
