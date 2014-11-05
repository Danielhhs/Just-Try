//
//  KeyConstants.h
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyConstants : NSObject

+ (NSString *) fontKey;
+ (NSString *) alignmentKey;
+ (NSString *) rotationKey;
+ (NSString *) reflectionKey;
+ (NSString *) shadowKey;
+ (NSString *) reflectionAlphaKey;
+ (NSString *) reflectionSizeKey;
+ (NSString *) shadowAlphaKey;
+ (NSString *) shadowSizeKey;
+ (NSString *) imageNameKey;
+ (NSString *) attibutedStringKey;
+ (NSString *) frameKey;
+ (NSString *) restoreKey;
+ (NSString *) viewOpacityKey;
+ (NSString *) transformKey;
+ (NSString *) textSelectionKey;
+ (NSString *) centerKey;

+(NSString *) addKey;
+(NSString *) deleteKey;

@end
