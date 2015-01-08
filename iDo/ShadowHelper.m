//
//  ShadowHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/29/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ShadowHelper.h"
#import "KeyConstants.h"
#import "GenericContainerView.h"
#import "ShadowType.h"

#define SHADOW_CURL_FACTOR 0.618
#define MAX_SHADOW_DEPTH_RATIO 0.1
#define PROJECTION_MIN_WIDTH_RATIO 0.5
#define PROJECTION_MAX_WIDTH_RATION 1
#define PROJECTION_HEIGHT_WIDHT_RATIO 0.138
#define SPACE_BETWEEN_PROJECTION_RATIO 0.05
#define SPACE_BETWEEN_PROJECTION 30

@implementation ShadowHelper

+ (UIBezierPath *) stereoShadowPathWithBounds:(CGRect) contentFrame shadowDepth:(CGFloat) shadowDepth
{
    CGFloat curlFactor = SHADOW_CURL_FACTOR;
    CGFloat minX = CGRectGetMinX(contentFrame);
    CGFloat minY = CGRectGetMaxY(contentFrame);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(minX, minY + shadowDepth)];
    [path addLineToPoint:CGPointMake(minX, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY)];
    [path addLineToPoint:CGPointMake(minX + contentFrame.size.width, minY + shadowDepth)];
    [path addCurveToPoint:CGPointMake(minX, minY + shadowDepth)
            controlPoint1:CGPointMake(minX + contentFrame.size.width * (1 - curlFactor), minY + shadowDepth * (1 - curlFactor))
            controlPoint2:CGPointMake(minX + contentFrame.size.width * curlFactor, minY + shadowDepth * (1 - curlFactor))];
    return path;
}

+ (UIBezierPath *) surroundingShadowPathWithBounds:(CGRect) bounds shadowDepath:(CGFloat) shadowDepth
{
    shadowDepth *= 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectInset(bounds, -1 * shadowDepth, -1 * shadowDepth)];
    return path;
}

+ (UIBezierPath *) projectionShadowPathWithBounds:(CGRect)bounds shadowDepthRatio:(CGFloat) shadowDepthRatio
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bounds];
    return path;
}

+ (UIBezierPath *) offsetShadowPathWithBoudns:(CGRect) bounds shadowDepth: (CGFloat) shadowDepth
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectOffset(bounds, shadowDepth, shadow)];
    return path;
}

+ (UIView *) shadowAppliedToViewFromContainer:(GenericContainerView *) container shadowType:(ContentViewShadowType) shadowType
{
    if (shadowType == ContentViewShadowTypeProjection) {
        if (container.shadow == nil) {
            [ShadowHelper createShadowForContainer:container];
        }
        return container.shadow;
    }
    return [container contentView];
}

+ (void) createShadowForContainer:(GenericContainerView *) container
{
    CGFloat width = container.frame.size.width;
    CGFloat height = width * PROJECTION_HEIGHT_WIDHT_RATIO;
    CGFloat x = (container.frame.size.width - width) / 2;
    CGFloat containerFrameHeight = CGRectGetMaxY(container.frame) - container.frame.origin.y;
    CGFloat y = (1 + SPACE_BETWEEN_PROJECTION_RATIO) * containerFrameHeight;
    container.shadow = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [container addSubview:container.shadow];
}

+ (void) applyProjectionShadowToGenericContainer:(GenericContainerView *)container shadowDepthRatio:(CGFloat) shadowDepthRatio
{
    CGFloat width = container.frame.size.width * shadowDepthRatio;
    CGFloat height = width * PROJECTION_HEIGHT_WIDHT_RATIO;
    container.shadow.bounds = CGRectMake(0, 0, width, height);
    container.shadow.transform = CGAffineTransformInvert(container.transform);
    CGFloat centerY = CGRectGetMaxY(container.frame) + container.shadow.bounds.size.height / 2 + SPACE_BETWEEN_PROJECTION;
    CGPoint center = [container convertPoint:CGPointMake(container.center.x, centerY) fromView:[container superview]];
    container.shadow.center = center;
    container.shadow.hidden = NO;
    container.shadow.layer.shadowPath = [ShadowHelper projectionShadowPathWithBounds:container.shadow.bounds shadowDepthRatio:shadowDepthRatio].CGPath;
}

+ (void) applyShadowToGenericContainerView:(GenericContainerView *)container
{
    GenericContentDTO *attributes = container.attributes;
    ContentViewShadowType shadowType = attributes.shadowType;
    [ShadowHelper applyShadowWithAttributes:attributes shadowType:shadowType toGenericContent:container];
}

+ (void) applyShadowWithAttributes:(GenericContentDTO *)attributes
                        shadowType:(ContentViewShadowType) shadowType
                  toGenericContent:(GenericContainerView *)container
{
    [ShadowHelper hideShadowForGenericContainerView:container];
    BOOL showShadow = attributes.shadow;
    if (!showShadow) {
        [container.shadow removeFromSuperview];
        container.shadow = nil;
        return;
    }
    UIView *content = [container contentView];
    CGFloat shadowDepthRatio = attributes.shadowSize;
    CGRect bounds = attributes.bounds;
    CGFloat shadowDepth = MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * bounds.size.height;
    UIView *shadowAppliedTo = [ShadowHelper shadowAppliedToViewFromContainer:container shadowType:shadowType];
    switch (shadowType) {
        case ContentViewShadowTypeStereo:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper stereoShadowPathWithBounds:content.bounds shadowDepth:shadowDepth].CGPath;
            break;
        case ContentViewShadowTypeOffset:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper offsetShadowPathWithBoudns:content.bounds shadowDepth:shadowDepth].CGPath;
            break;
        case ContentViewShadowTypeSurrounding:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper surroundingShadowPathWithBounds:content.bounds shadowDepath:shadowDepth].CGPath;
            break;
        case ContentViewShadowTypeProjection:
            [ShadowHelper applyProjectionShadowToGenericContainer:container shadowDepthRatio:shadowDepthRatio];
            break;
        case ContentViewShadowTypeNone:
            [ShadowHelper hideShadowForGenericContainerView:container];
        default:
            break;
    }
    shadowAppliedTo.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowAppliedTo.layer.masksToBounds = NO;
    shadowAppliedTo.layer.shadowOpacity = attributes.shadowAlpha;
}

+ (void) updateShadowOpacity:(CGFloat)shadowOpacity toGenericContainerView:(GenericContainerView *)container
{
    GenericContentDTO *attributes = container.attributes;
    ContentViewShadowType shadowType = attributes.shadowType;
    UIView *shadowAppliedTo = [ShadowHelper shadowAppliedToViewFromContainer:container shadowType:shadowType];
    shadowAppliedTo.layer.shadowOpacity = shadowOpacity;
}

+ (void) hideShadowForGenericContainerView:(GenericContainerView *)container
{
    [container contentView].layer.shadowColor = [UIColor clearColor].CGColor;
    [container contentView].layer.shadowPath = NULL;
    [container contentView].layer.shadowOpacity = 0;
    container.shadow.layer.shadowColor = [UIColor clearColor].CGColor;
    container.shadow.layer.shadowPath = NULL;
    container.shadow.layer.shadowOpacity = 0;
}

+ (NSArray *) shadowTypes
{
    NSMutableArray *types = [NSMutableArray array];
    
    ShadowType *stereoType = [[ShadowType alloc] init];
    stereoType.type = ContentViewShadowTypeStereo;
    stereoType.desc = @"StereoType";
    stereoType.thumbnailName = @"stereoShadow.jpg";
    [types addObject:stereoType];
    ShadowType *offsetType = [[ShadowType alloc] init];
    offsetType.type = ContentViewShadowTypeOffset;
    offsetType.desc = @"OffsetType";
    offsetType.thumbnailName = @"offsetShadow.jpg";
    [types addObject:offsetType];
    ShadowType *surroudingType = [[ShadowType alloc] init];
    surroudingType.type = ContentViewShadowTypeSurrounding;
    surroudingType.desc = @"SurroundingType";
    surroudingType.thumbnailName = @"surroundingShadow.jpg";
    [types addObject:surroudingType];
    ShadowType *projectionType = [[ShadowType alloc] init];
    projectionType.type = ContentViewShadowTypeProjection;
    projectionType.desc = @"ProjectionType";
    projectionType.thumbnailName = @"projectionShadow.jpg";
    [types addObject:projectionType];
    
    return [types copy];
}
@end
