//
//  KeyConstants.m
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "KeyConstants.h"

@implementation KeyConstants

#pragma mark - Proposal
+ (NSString *) proposalNameKey
{
    return @"PROPOSAL_NAME";
}

+ (NSString *) proposalGamesKey
{
    return @"PROPOSAL_GAMES";
}

+ (NSString *) proposalSlidesKey
{
    return @"PROPOSAL_SLIDES";
}

+ (NSString *) proposalThumbnailKey
{
    return @"PROPOSAL_THUMBNAIL";
}

+ (NSString *) proposalCurrentSelectedSlideKey
{
    return @"PROPOSAL_CURRENT_SELECTED_SLIDE";
}
#pragma mark - Slide

+ (NSString *) slideBackgroundKey
{
    return @"SLIDE_BACKGROUND";
}

+ (NSString *) slideContentsKey
{
    return @"SLIDE_CONTENTS";
}

+ (NSString *) slideThumbnailKey
{
    return @"SLIDE_THUMBNAIL";
}

+ (NSString *) slideIndexKey
{
    return @"SLIDE_INDEX";
}

+ (NSString *) slideUniqueKey
{
    return @"SLIDE_UNIQUE";
}

#pragma mark - Generic Content
+ (NSString *) rotationKey
{
    return @"ROTATION";
}

+ (NSString *) reflectionKey
{
    return @"REFLECTION";
}

+ (NSString *) reflectionTypeKey
{
    return @"REFLECITON_TYPE";
}

+ (NSString *) shadowKey
{
    return @"SHADOW";
}

+ (NSString *) shadowTypeKey
{
    return @"SHADOW_TYPE";
}

+ (NSString *) reflectionAlphaKey
{
    return @"REFLECTION_ALPHA";
}

+ (NSString *) reflectionSizeKey
{
    return @"REFLECTION_SIZE";
}

+ (NSString *) shadowAlphaKey
{
    return @"SHADOW_ALPHA";
}

+ (NSString *) shadowSizeKey
{
    return @"SHADOW_SIZE";
}
+ (NSString *) boundsKey
{
    return @"BOUNDS";
}

+ (NSString *) viewOpacityKey
{
    return @"VIEW_OPACITY";
}

+ (NSString *) transformKey
{
    return @"TRANSFORM";
}

+ (NSString *) centerKey
{
    return @"CENTER";
}
+ (NSString *) contentTypeKey
{
    return @"CONTENT_TYPE";
}

#pragma mark - Text Content
+ (NSString *) fontKey
{
    return @"FONT";
}

+ (NSString *) alignmentKey
{
    return @"ALIGNMENT";
}

+ (NSString *) attibutedStringKey
{
    return @"ATTRIBUTED_STRING";
}

+ (NSString *) textSelectionKey
{
    return @"TEXT_SELECTION";
}

+ (NSString *) textColorKey
{
    return @"TEXT_COLOR";
}

+ (NSString *) textBackgroundColorKey
{
    return @"TEXT_BACKGROUND_COLOR";
}

#pragma mark - Image Content
+ (NSString *) imageNameKey
{
    return @"IMAGE_NAME";
}

+ (NSString *) filterKey
{
    return @"FILTER";
}

#pragma mark - Animation
+ (NSString *) animationsKey
{
    return @"ANIMATIONS";
}

+ (NSString *) animationDurationKey
{
    return @"ANIMATION_DURATION";
}

+ (NSString *) animationEffectKey
{
    return @"ANIMATION_EFFECT";
}

+ (NSString *) animationDirectionKey
{
    return @"ANIMATION_DIRECTION";
}

+ (NSString *) animationIndexKey
{
    return @"ANIMATION_INDEX";
}

+ (NSString *) animationTriggerTimeKey
{
    return @"ANIMATION_TRIGGER_TIME";
}

+ (NSString *) animationEventKey
{
    return @"ANIMATION_EVENT";
}

#pragma mark - Operation

+ (NSString *) addKey
{
    return @"ADD";
}

+ (NSString *) deleteKey
{
    return @"DELETE";
}

+ (NSString *) uniqueKey
{
    return @"UNIQUE";
}
@end
