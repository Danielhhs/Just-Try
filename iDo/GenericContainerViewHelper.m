//
//  GenericContainerViewHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerViewHelper.h"
#import "KeyConstants.h"
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


+ (NSMutableDictionary *) defaultContentAttributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[KeyConstants shadowAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[KeyConstants shadowSizeKey]];
    [attributes setValue:@(GOLDEN_RATIO) forKey:[KeyConstants reflectionAlphaKey]];
    [attributes setValue:@(COUNTER_GOLDEN_RATIO) forKey:[KeyConstants reflectionSizeKey]];
    [attributes setValue:@(NO) forKey:[KeyConstants reflectionKey]];
    [attributes setValue:@(NO) forKey:[KeyConstants shadowKey]];
    [attributes setValue:@(1) forKey:[KeyConstants viewOpacityKey]];
    return attributes;
}

+ (NSDictionary *) defaultImageAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:DEFAULT_IMAGE_NAME forKey:[KeyConstants imageNameKey]];
    UIImage *image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    CGFloat scale = image.size.width / image.size.height;
    CGFloat width = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGFloat height = scale > 1 ? DEFAULT_IMAGE_EDGE : DEFAULT_IMAGE_EDGE / scale;
    CGRect frame = CGRectMake(200, 300, width, height);
    [attributes setObject:[NSValue valueWithCGRect:frame] forKey:[KeyConstants frameKey]];
    return [attributes copy];
}

+ (NSDictionary *) defaultTextAttributes
{
    NSMutableDictionary *attributes = [GenericContainerViewHelper defaultContentAttributes];
    [attributes setObject:[TextFontHelper defaultFont] forKey:[KeyConstants fontKey]];
    [attributes setObject:@(TextAlignmentLeft) forKey:[KeyConstants alignmentKey]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:PLACE_HOLDER_STRING
                                                                           attributes:@{NSFontAttributeName : [TextFontHelper defaultFont],
                                                                                        NSParagraphStyleAttributeName : paragraphStyle}];
    [attributes setObject:attributedString forKey:[KeyConstants attibutedStringKey]];
    NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(200, 300, DEFAULT_TEXT_CONTAINER_WIDTH, 2 * CONTROL_POINT_SIZE_HALF + DEFAULT_TEXT_CONTAINER_HEIGHT)];
    [attributes setObject:frameValue forKey:[KeyConstants frameKey]];
    return [attributes copy];
}

+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes
{
    for (NSString *key in [changedAttributes allKeys]) {
        if (![key isEqualToString:[KeyConstants restoreKey]]) {
            [fullAttributes setValue:changedAttributes[key] forKey:key];
        }
    }
}

+ (void) applyAttribute:(NSDictionary *)attributes
            toContainer:(GenericContainerView *)containerView
{
    [GenericContainerViewHelper applyNoAnimationAttribute:attributes toContainer:containerView];
    NSNumber *rotation = attributes[[KeyConstants rotationKey]];
    if (rotation) {
        [GenericContainerViewHelper applyRotation:[rotation doubleValue] toView:containerView];
    }
    NSNumber *restore = attributes[[KeyConstants restoreKey]];
    if (restore) {
        containerView.transform = CGAffineTransformIdentity;
        [containerView hideRotationIndicator];
    }
}

+ (void) applyNoAnimationAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView
{
    NSNumber *viewOpacity = attributes[[KeyConstants viewOpacityKey]];
    if (viewOpacity) {
        containerView.alpha = [viewOpacity doubleValue];
    }
    NSNumber *reflection = attributes[[KeyConstants reflectionKey]];
    if (reflection) {
        containerView.reflection.hidden = ![reflection boolValue];
        if (containerView.reflection.hidden == NO) {
            CGFloat reflectionHeight = [containerView.attributes[[KeyConstants reflectionSizeKey]] floatValue];
            [containerView.reflection updateReflectionWithWithReflectionHeight:reflectionHeight];
        }
    }
    NSNumber *reflectionAlpha = attributes[[KeyConstants reflectionAlphaKey]];
    if (reflectionAlpha) {
        containerView.reflection.alpha = [reflectionAlpha floatValue];
    }
    NSNumber *reflectionSize = attributes[[KeyConstants reflectionSizeKey]];
    if (reflectionSize) {
        containerView.reflection.height = [reflectionSize floatValue];
    }
    NSNumber *shadow = attributes[[KeyConstants shadowKey]];
    if (shadow) {
        containerView.showShadow = [shadow boolValue];
    }
    NSNumber *shadowAlpha = attributes[[KeyConstants shadowAlphaKey]];
    if (shadowAlpha) {
        containerView.layer.shadowOpacity = [shadowAlpha floatValue];
    }
    NSNumber *shadowSize = attributes[[KeyConstants shadowSizeKey]];
    if (shadowSize) {
        containerView.layer.shadowPath = [ShadowHelper shadowPathWithShadowDepthRatio:[shadowSize doubleValue] originalViewHeight:containerView.bounds.size.height originalViewContentFrame:containerView.originalContentFrame].CGPath;
    }
    NSValue *frame = attributes[[KeyConstants frameKey]];
    if (frame) {
        containerView.frame = [frame CGRectValue];
    }
    NSValue *center = attributes[[KeyConstants centerKey]];
    if (center) {
        containerView.center = [center CGPointValue];
    }
}

+ (void) applyUndoAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView
{
    [GenericContainerViewHelper applyNoAnimationAttribute:attributes toContainer:containerView];
    NSValue *transform = attributes[[KeyConstants transformKey]];
    if (transform) {
        containerView.transform = [transform CGAffineTransformValue];
        [containerView hideRotationIndicator];
    }
}

+ (CGFloat) anglesFromTransform:(CGAffineTransform)transform
{
    CGFloat radians = atan2(transform.b, transform.a);
    return radians / M_PI * ANGELS_PER_PI;
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
