//
//  GenericContainerViewHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ANGELS_PER_PI 180

@interface GenericContainerViewHelper : NSObject
+ (NSString *) boldKey;
+ (NSString *) italicKey;
+ (NSString *) fontKey;
+ (NSString *) fontSizeKey;
+ (NSString *) alignmentKey;
+ (NSString *) rotationKey;
+ (NSString *) reflectionKey;
+ (NSString *) shadowKey;
+ (NSString *) reflectionAlphaKey;
+ (NSString *) reflectionSizeKey;
+ (NSString *) shadowAlphaKey;
+ (NSString *) shadowSizeKey;
@end