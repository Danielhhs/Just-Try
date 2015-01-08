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
#import "Enums.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "ReflectionHelper.h"
#import "GenericContentDTO.h"

@implementation GenericContainerViewHelper


+ (void) mergeChangedAttributes:(NSDictionary *) changedAttributes
             withFullAttributes:(GenericContentDTO *) fullAttributes
             inGenericContainer:(GenericContainerView *) container
{
    for (NSString *key in [changedAttributes allKeys]) {
        if ([key isEqualToString:[KeyConstants centerKey]]) {
            fullAttributes.center = [changedAttributes[[KeyConstants centerKey]] CGPointValue];
            container.center = fullAttributes.center;
        } else if ([key isEqualToString:[KeyConstants boundsKey]]) {
            fullAttributes.bounds = [changedAttributes[[KeyConstants boundsKey]] CGRectValue];
            container.bounds = fullAttributes.bounds;
        } else if ([key isEqualToString:[KeyConstants viewOpacityKey]]) {
            fullAttributes.opacity = [changedAttributes[[KeyConstants viewOpacityKey]] doubleValue];
            container.alpha = fullAttributes.opacity;
        } else if ([key isEqualToString:[KeyConstants reflectionKey]]) {
            fullAttributes.reflection = [changedAttributes[[KeyConstants reflectionKey]] boolValue];
            container.reflection.hidden = !fullAttributes.reflection;
            if (container.reflection.hidden == NO) {
                [ReflectionHelper applyReflectionViewToGenericContainerView:container];
            }
        } else if ([key isEqualToString:[KeyConstants shadowKey]]) {
            fullAttributes.shadow = [changedAttributes[[KeyConstants shadowKey]] boolValue];
                [ShadowHelper applyShadowToGenericContainerView:container];
        } else if ([key isEqualToString:[KeyConstants reflectionAlphaKey]]) {
            fullAttributes.reflectionAlpha = [changedAttributes[[KeyConstants reflectionAlphaKey]] doubleValue];
            container.reflection.alpha = fullAttributes.reflectionAlpha;
        } else if ([key isEqualToString:[KeyConstants reflectionSizeKey]]) {
            fullAttributes.reflectionSize = [changedAttributes[[KeyConstants reflectionSizeKey]] doubleValue];
            container.reflection.height = fullAttributes.reflectionSize;
        } else if ([key isEqualToString:[KeyConstants shadowTypeKey]]) {
            fullAttributes.shadowType = [changedAttributes[[KeyConstants shadowTypeKey]] integerValue];
            [ShadowHelper applyShadowToGenericContainerView:container];
        } else if ([key isEqualToString:[KeyConstants shadowAlphaKey]]) {
            fullAttributes.shadowAlpha = [changedAttributes[[KeyConstants shadowAlphaKey]] doubleValue];
            [ShadowHelper applyShadowToGenericContainerView:container];
        } else if ([key isEqualToString:[KeyConstants shadowSizeKey]]) {
            fullAttributes.shadowSize = [changedAttributes[[KeyConstants shadowSizeKey]] doubleValue];
            [ShadowHelper applyShadowToGenericContainerView:container];
        } else if ([key isEqualToString:[KeyConstants transformKey]]) {
            fullAttributes.transform = [changedAttributes[[KeyConstants transformKey]] CGAffineTransformValue];
            container.transform = fullAttributes.transform;
        }
    }
}

+ (void) applyAttribute:(GenericContentDTO *)attributes
            toContainer:(GenericContainerView *)containerView
{
    containerView.alpha = attributes.opacity;
    containerView.bounds = attributes.bounds;
    containerView.center = attributes.center;
    containerView.transform = attributes.transform;
    containerView.reflection.hidden = !attributes.reflection;
    if (containerView.reflection.hidden == NO) {
        [ReflectionHelper applyReflectionViewToGenericContainerView:containerView];
    }
    containerView.reflection.alpha = attributes.reflectionAlpha;
    containerView.reflection.height = attributes.reflectionSize;
    [ShadowHelper applyShadowToGenericContainerView:containerView];
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

+ (CGRect) frameFromAttributes:(GenericContentDTO *)attributes
{
    CGRect bounds = attributes.bounds;
    CGPoint center = attributes.center;
    return [GenericContainerViewHelper frameFromBounds:bounds center:center];
}

+ (CGRect) frameFromBounds:(CGRect)bounds center:(CGPoint)center
{
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat midY = CGRectGetMidY(bounds);
    CGRect frame = CGRectOffset(bounds, center.x - midX, center.y - midY);
    return frame;
}

+ (GenericContainerView *) contentViewFromAttributes:(GenericContentDTO *)attributes delegate:(id<ContentContainerViewDelegate>)delegate
{
    GenericContainerView *content = nil;
    ContentViewType type = attributes.contentType;
    switch (type) {
        case ContentViewTypeImage:
            content = [[ImageContainerView alloc] initWithAttributes:(ImageContentDTO *)attributes delegate:delegate];
            break;
        case ContentViewTypeText:
            content = [[TextContainerView alloc] initWithAttributes:(TextContentDTO *)attributes delegate:delegate];
            
        default:
            break;
    }
    return content;
}
@end
