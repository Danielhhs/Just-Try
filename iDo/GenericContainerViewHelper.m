//
//  GenericContainerViewHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerViewHelper.h"
#import <UIKit/UIKit.h>
#import "TextFontHelper.h"
#import "ShadowHelper.h"
#import "ReflectionView.h"

#define DEFAULT_IMAGE_EDGE 300

#define DEFAULT_TEXT_CONTAINER_WIDTH 300.f
#define DEFAULT_TEXT_CONTAINER_HEIGHT 30
#define DEFAULT_IMAGE_NAME @"background.jpg"
#define PLACE_HOLDER_STRING @"Any Thing You Want to Say"

@implementation GenericContainerViewHelper

+ (NSString *) fontKey
{
    return @"FONT";
}

+ (NSString *) alignmentKey
{
    return @"ALIGNMENT";
}

+ (NSString *) rotationKey
{
    return @"ROTATION";
}

+ (NSString *) reflectionKey
{
    return @"REFLECTION";
}

+ (NSString *) shadowKey
{
    return @"SHADOW";
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

+ (NSString *) imageNameKey
{
    return @"IMAGE_NAME";
}

+ (NSString *) attibutedStringKey
{
    return @"ATTRIBUTED_STRING";
}

+ (NSString *) frameKey
{
    return @"FRAME";
}

+ (NSString *) restoreKey
{
    return @"RESTORE";
}

+ (NSMutableDictionary *) defaultContentAttributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[GenericContainerViewHelper shadowAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[GenericContainerViewHelper shadowSizeKey]];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[GenericContainerViewHelper reflectionAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[GenericContainerViewHelper reflectionSizeKey]];
    [attributes setValue:@(NO) forKey:[GenericContainerViewHelper reflectionKey]];
    [attributes setValue:@(NO) forKey:[GenericContainerViewHelper shadowKey]];
    return attributes;
}

+ (NSDictionary *) defaultImageAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:DEFAULT_IMAGE_NAME forKey:[GenericContainerViewHelper imageNameKey]];
    UIImage *image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    CGFloat scale = image.size.width / image.size.height;
    CGFloat width = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGFloat height = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGRect frame = CGRectMake(200, 300, width, height);
    [attributes setObject:[NSValue valueWithCGRect:frame] forKey:[GenericContainerViewHelper frameKey]];
    return [attributes copy];
}

+ (NSDictionary *) defaultTextAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:[TextFontHelper defaultFont] forKey:[GenericContainerViewHelper fontKey]];
    [attributes setObject:@(TextAlignmentLeft) forKey:[GenericContainerViewHelper alignmentKey]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:PLACE_HOLDER_STRING
                                                                           attributes:@{NSFontAttributeName : [TextFontHelper defaultFont],
                                                                                        NSParagraphStyleAttributeName : paragraphStyle}];
    [attributes setObject:attributedString forKey:[GenericContainerViewHelper attibutedStringKey]];
    NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(200, 300, DEFAULT_TEXT_CONTAINER_WIDTH, 2 * CONTROL_POINT_SIZE_HALF + DEFAULT_TEXT_CONTAINER_HEIGHT)];
    [attributes setObject:frameValue forKey:[GenericContainerViewHelper frameKey]];
    return [attributes copy];
}

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes
{
    for (NSString *key in [changedAttributes allKeys]) {
        [fullAttributes setValue:changedAttributes[key] forKey:key];
    }
}

+ (void) applyAttribute:(NSMutableDictionary *)attributes
            toContainer:(GenericContainerView *)containerView
{
    NSNumber *rotation = attributes[[GenericContainerViewHelper rotationKey]];
    if (rotation) {
        [GenericContainerViewHelper applyRotation:[rotation doubleValue] toView:containerView];
    }
    NSNumber *reflection = attributes[[GenericContainerViewHelper reflectionKey]];
    if (reflection) {
        containerView.reflection.hidden = ![reflection boolValue];
        if (containerView.reflection.hidden == NO) {
            CGFloat reflectionHeight = [containerView.attributes[[GenericContainerViewHelper reflectionSizeKey]] floatValue];
            [containerView.reflection updateReflectionWithWithReflectionHeight:reflectionHeight];
        }
    }
    NSNumber *reflectionAlpha = attributes[[GenericContainerViewHelper reflectionAlphaKey]];
    if (reflectionAlpha) {
        containerView.reflection.alpha = [reflectionAlpha floatValue];
    }
    NSNumber *reflectionSize = attributes[[GenericContainerViewHelper reflectionSizeKey]];
    if (reflectionSize) {
        containerView.reflection.height = [reflectionSize floatValue];
    }
    NSNumber *shadow = attributes[[GenericContainerViewHelper shadowKey]];
    if (shadow) {
        containerView.showShadow = [shadow boolValue];
    }
    NSNumber *shadowAlpha = attributes[[GenericContainerViewHelper shadowAlphaKey]];
    if (shadowAlpha) {
        containerView.layer.shadowOpacity = [shadowAlpha floatValue];
    }
    NSNumber *shadowSize = attributes[[GenericContainerViewHelper shadowSizeKey]];
    if (shadowSize) {
        containerView.layer.shadowPath = [ShadowHelper shadowPathWithShadowDepthRatio:[shadowSize doubleValue] originalViewHeight:containerView.bounds.size.height originalViewContentFrame:containerView.originalContentFrame].CGPath;
    }
    NSNumber *restore = attributes[[GenericContainerViewHelper restoreKey]];
    if (restore) {
        containerView.transform = CGAffineTransformIdentity;
        [attributes removeObjectForKey:[GenericContainerViewHelper restoreKey]];
        [containerView hideRotationIndicator];
    }
}

static CGAffineTransform actualTransform;

+ (void) applyRotation:(CGFloat) rotation
                toView:(UIView *) view
{
    actualTransform = CGAffineTransformRotate(actualTransform, rotation);
    CGFloat actualRotation = atan2f(actualTransform.b, actualTransform.a);
    actualRotation = actualRotation / M_PI * ANGELS_PER_PI;
    if ((actualRotation > -5 && actualRotation < 5) || (actualRotation > 355 && actualRotation < 360)) {
        actualRotation = 0;
    } else if (actualRotation > 85 && actualRotation < 95) {
        actualRotation = 90;
    } else if (actualRotation > 175 && actualRotation < 185) {
        actualRotation = 180;
    } else if (actualRotation > 220 && actualRotation < 230) {
        actualRotation = 225;
    }
    view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, actualRotation / ANGELS_PER_PI * M_PI);
}

+ (void) resetActualTransformWithView:(GenericContainerView *) container
{
    actualTransform = container.transform;
}
@end
