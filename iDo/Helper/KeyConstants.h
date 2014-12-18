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
+ (NSString *) proposalCurrentSelectedSlideKey;

#pragma mark - Slide
+ (NSString *) slideBackgroundKey;
+ (NSString *) slideContentsKey;
+ (NSString *) slideThumbnailKey;
+ (NSString *) slideIndexKey;
+ (NSString *) slideUniqueKey;
+ (NSString *) slideCurrentAnimationIndexKey;

#pragma mark - Generic Content
+ (NSString *) rotationKey;
+ (NSString *) reflectionKey;
+ (NSString *) reflectionTypeKey;
+ (NSString *) shadowKey;
+ (NSString *) shadowTypeKey;
+ (NSString *) reflectionAlphaKey;
+ (NSString *) reflectionSizeKey;
+ (NSString *) shadowAlphaKey;
+ (NSString *) shadowSizeKey;
+ (NSString *) boundsKey;
+ (NSString *) viewOpacityKey;
+ (NSString *) transformKey;
+ (NSString *) centerKey;
+ (NSString *) contentTypeKey;
+ (NSString *) contentUUIDKey;

#pragma mark - Text Content
+ (NSString *) fontKey;
+ (NSString *) alignmentKey;
+ (NSString *) textSelectionKey;
+ (NSString *) attibutedStringKey;
+ (NSString *) textColorKey;
+ (NSString *) textBackgroundColorKey;

#pragma mark - Image Content
+ (NSString *) imageNameKey;
+ (NSString *) filterKey;

#pragma mark - Animiation
+ (NSString *) animationsKey;
+ (NSString *) animationDurationKey;
+ (NSString *) animationEffectKey;
+ (NSString *) animationIndexKey;
+ (NSString *) animationDirectionKey;
+ (NSString *) animationTriggerTimeKey;
+ (NSString *) animationEventKey;

+(NSString *) addKey;
+(NSString *) deleteKey;
+ (NSString *) uniqueKey;

@end
