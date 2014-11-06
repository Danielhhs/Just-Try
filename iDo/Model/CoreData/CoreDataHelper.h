//
//  CoreDataHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject


+ (NSData *) encodeNSValue:(NSValue *)value;
+ (NSValue *) decodeNSData:(NSData *)data;
@end
