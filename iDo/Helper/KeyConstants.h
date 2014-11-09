//
//  KeyConstants.h
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyConstants : NSObject

#pragma mark - Proposal
+ (NSString *) proposalNameKey;
+ (NSString *) proposalSlidesKey;
+ (NSString *) proposalGamesKey;
+ (NSString *) proposalThumbnailKey;

#pragma mark - Slide
+ (NSString *) slideBackgroundKey;
+ (NSString *) slideContentsKey;
+ (NSString *) slideThumbnailKey;

#pragma mark - Generic Content
+ (NSString *) rotationKey;
+ (NSString *) reflectionKey;
+ (NSString *) shadowKey;
+ (NSString *) reflectionAlphaKey;
+ (NSString *) reflectionSizeKey;
+ (NSString *) shadowAlphaKey;
+ (NSString *) shadowSizeKey;
+ (NSString *) boundsKey;
+ (NSString *) viewOpacityKey;
+ (NSString *) transformKey;
+ (NSString *) centerKey;
+ (NSString *) contentTypeKey;

#pragma mark - Text Content
+ (NSString *) fontKey;
+ (NSString *) alignmentKey;
+ (NSString *) textSelectionKey;
+ (NSString *) attibutedStringKey;

#pragma mark - Image Content
+ (NSString *) imageNameKey;
+ (NSString *) filterKey;

+(NSString *) addKey;
+(NSString *) deleteKey;
+ (NSString *) uniqueKey;

@end
