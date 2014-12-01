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
#import "DrawingConstants.h"
#import "GenericContentConstants.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "ReflectionHelper.h"

@implementation GenericContainerViewHelper


+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(NSMutableDictionary *) fullAttributes
{
    for (NSString *key in [changedAttributes allKeys]) {
        [fullAttributes setValue:changedAttributes[key] forKey:key];
    }
}

+ (void) applyAttribute:(NSDictionary *)attributes
            toContainer:(GenericContainerView *)containerView
{
    [GenericContainerViewHelper applyNoAnimationAttribute:attributes toContainer:containerView];
}

+ (void) applyNoAnimationAttribute:(NSDictionary *)attributes toContainer:(GenericContainerView *)containerView
{
    NSNumber *viewOpacity = attributes[[KeyConstants viewOpacityKey]];
    if (viewOpacity) {
        containerView.alpha = [viewOpacity doubleValue];
    }
    NSValue *bounds = attributes[[KeyConstants boundsKey]];
    if (bounds) {
        containerView.bounds = [bounds CGRectValue];
    }
    NSValue *center = attributes[[KeyConstants centerKey]];
    if (center) {
        containerView.center = [center CGPointValue];
    }
    NSValue *transform = attributes[[KeyConstants transformKey]];
    if (transform) {
        containerView.transform = [transform CGAffineTransformValue];
    }
    NSNumber *reflection = attributes[[KeyConstants reflectionKey]];
    if (reflection) {
        containerView.reflection.hidden = ![reflection boolValue];
        if (containerView.reflection.hidden == NO) {
            [ReflectionHelper applyReflectionViewToGenericContainerView:containerView];
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
    NSNumber *shadowType = attributes[[KeyConstants shadowTypeKey]];
    NSNumber *shadowAlpha = attributes[[KeyConstants shadowAlphaKey]];
    NSNumber *shadowSize = attributes[[KeyConstants shadowSizeKey]];
    if (shadowSize || shadow || shadowType || shadowAlpha) {
        [ShadowHelper applyShadowToGenericContainerView:containerView];
    }
}

+ (CGFloat) anglesFromTransform:(CGAffineTransform)transform
{
    CGFloat radians = atan2(transform.b, transform.a);
    return radians / M_PI * [DrawingConstants angelsPerPi];
}

static CGAffineTransform actualTransform;

+ (void) applyRotation:(CGFloat) rotation
                toView:(UIView *) view
{
    actualTransform = CGAffineTransformRotate(actualTransform, rotation);
    CGFloat actualRotation = atan2f(actualTransform.b, actualTransform.a);
    actualRotation = actualRotation / M_PI * [DrawingConstants angelsPerPi];
    if ((actualRotation > -3 && actualRotation < 3) || (actualRotation > 357 && actualRotation < 360)) {
        actualRotation = 0;
    } else if (actualRotation > 43 && actualRotation < 47) {
        actualRotation = 45;
    } else if (actualRotation > 87 && actualRotation < 93) {
        actualRotation = 90;
    } else if (actualRotation > 133 && actualRotation < 137) {
        actualRotation = 135;
    } else if ((actualRotation > 177 && actualRotation < 183) || (actualRotation > -183 && actualRotation < -177)) {
        actualRotation = 180;
    } else if (actualRotation > -47 && actualRotation < -43) {
        actualRotation = -45;
    } else if (actualRotation > -137 && actualRotation < -133) {
        actualRotation = -135;
    } else if (actualRotation > -93 && actualRotation < -87) {
        actualRotation = -90;
    }
    view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, actualRotation / [DrawingConstants angelsPerPi] * M_PI);
}

+ (void) resetActualTransformWithView:(GenericContainerView *) container
{
    actualTransform = container.transform;
}

+ (CGRect) frameFromAttributes:(NSDictionary *)attributes
{
    CGRect bounds = [attributes[[KeyConstants boundsKey]] CGRectValue];
    CGPoint center = [attributes[[KeyConstants centerKey]] CGPointValue];
    return [GenericContainerViewHelper frameFromBounds:bounds center:center];
}

+ (CGRect) frameFromBounds:(CGRect)bounds center:(CGPoint)center
{
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat midY = CGRectGetMidY(bounds);
    CGRect frame = CGRectOffset(bounds, center.x - midX, center.y - midY);
    return frame;
}

+ (GenericContainerView *) contentViewFromAttributes:(NSMutableDictionary *)attributes delegate:(id<ContentContainerViewDelegate>)delegate
{
    GenericContainerView *content = nil;
    ContentViewType type = [attributes[[KeyConstants contentTypeKey]] integerValue];
    switch (type) {
        case ContentViewTypeImage:
            content = [[ImageContainerView alloc] initWithAttributes:attributes delegate:delegate];
            break;
        case ContentViewTypeText:
            content = [[TextContainerView alloc] initWithAttributes:attributes delegate:delegate];
            
        default:
            break;
    }
    return content;
}
@end
