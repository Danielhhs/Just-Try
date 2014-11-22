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
#import "ReflectionShadowType.h"

#define SHADOW_CURL_FACTOR 0.618
#define MAX_SHADOW_DEPTH_RATIO 0.1
#define PROJECTION_MIN_WIDTH_RATIO 0.5
#define PROJECTION_MAX_WIDTH_RATION 1
#define PROJECTION_HEIGHT_WIDHT_RATIO 0.372
#define SPACE_BETWEEN_PROJECTION_RATIO 0.1

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
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectInset(bounds, -1 * shadowDepth, -1 * shadowDepth)];
    return path;
}

+ (UIBezierPath *) projectionShadowPathWithContainer:(GenericContainerView *)container shadowDepthRatio:(CGFloat) shadowDepthRatio
{
    CGFloat width = container.frame.size.width * (PROJECTION_MIN_WIDTH_RATIO + (PROJECTION_MAX_WIDTH_RATION - PROJECTION_MIN_WIDTH_RATIO) *shadowDepthRatio);
    CGFloat height = width * PROJECTION_HEIGHT_WIDHT_RATIO;
    CGFloat x = (container.frame.size.width - width) / 2;
    CGFloat containerFrameHeight = CGRectGetMaxY(container.frame) - container.frame.origin.y;
    CGFloat y = (1 + SPACE_BETWEEN_PROJECTION_RATIO) * containerFrameHeight;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, width, height)];
    return path;
}

+ (UIView *) shadowAppliedToViewFromContainer:(GenericContainerView *) container shadowType:(ContentViewShadowType) shadowType
{
    if (shadowType == ContentViewShadowTypeProjection) {
        return container;
    }
    return [container contentView];
}

+ (void) applyShadowToGenericContainerView:(GenericContainerView *)container
{
    NSDictionary *attributes = [container attributes];
    ContentViewShadowType shadowType = [attributes[[KeyConstants shadowTypeKey]] integerValue];
    [ShadowHelper applyShadowWithAttributes:(NSDictionary *)attributes shadowType:shadowType toGenericContent:container];
}

+ (void) applyShadowWithAttributes:(NSDictionary *)attributes
                        shadowType:(ContentViewShadowType) shadowType
                  toGenericContent:(GenericContainerView *)container
{
    UIView *content = [container contentView];
    CGFloat shadowDepthRatio = [attributes[[KeyConstants shadowSizeKey]] doubleValue];
    CGRect bounds = [attributes[[KeyConstants boundsKey]] CGRectValue];
    CGFloat shadowDepth = MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * bounds.size.height;
    UIView *shadowAppliedTo = [ShadowHelper shadowAppliedToViewFromContainer:container shadowType:shadowType];
    switch (shadowType) {
        case ContentViewShadowTypeStereo:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper stereoShadowPathWithBounds:content.bounds shadowDepth:shadowDepth].CGPath;
            break;
        case ContentViewShadowTypeOffset:
            shadowAppliedTo.layer.shadowOffset = CGSizeMake(MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * content.bounds.size.height, MAX_SHADOW_DEPTH_RATIO * shadowDepthRatio * content.bounds.size.height);
            break;
        case ContentViewShadowTypeSurrounding:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper surroundingShadowPathWithBounds:content.bounds shadowDepath:shadowDepth].CGPath;
            break;
        case ContentViewShadowTypeProjection:
            shadowAppliedTo.layer.shadowPath = [ShadowHelper projectionShadowPathWithContainer:container shadowDepthRatio:shadowDepthRatio].CGPath;
        default:
            break;
    }
    shadowAppliedTo.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowAppliedTo.layer.masksToBounds = NO;
    shadowAppliedTo.layer.shadowOpacity = 0.618;
}

+ (void) updateShadowOpacity:(CGFloat)shadowOpacity toGenericContainerView:(GenericContainerView *)container
{
    NSDictionary *attributes = [container attributes];
    ContentViewShadowType shadowType = [attributes[[KeyConstants shadowTypeKey]] integerValue];
    UIView *shadowAppliedTo = [ShadowHelper shadowAppliedToViewFromContainer:container shadowType:shadowType];
    shadowAppliedTo.layer.shadowOpacity = shadowOpacity;
}

+ (void) hideShadowForGenericContainerView:(GenericContainerView *)container
{
    NSDictionary *attributes = [container attributes];
    ContentViewShadowType shadowType = [attributes[[KeyConstants shadowTypeKey]] integerValue];
    UIView *shadowAppliedTo = [ShadowHelper shadowAppliedToViewFromContainer:container shadowType:shadowType];
    shadowAppliedTo.layer.shadowColor = [UIColor clearColor].CGColor;
}

+ (NSArray *) shadowTypes
{
    NSMutableArray *types = [NSMutableArray array];
    
    ReflectionShadowType *stereoType = [[ReflectionShadowType alloc] init];
    stereoType.type = ContentViewShadowTypeStereo;
    stereoType.desc = @"StereoType";
    stereoType.thumbnailName = @"stereoShadow.jpg";
    [types addObject:stereoType];
    ReflectionShadowType *offsetType = [[ReflectionShadowType alloc] init];
    offsetType.type = ContentViewShadowTypeOffset;
    offsetType.desc = @"OffsetType";
    offsetType.thumbnailName = @"offsetShadow.jpg";
    [types addObject:offsetType];
    ReflectionShadowType *surroudingType = [[ReflectionShadowType alloc] init];
    surroudingType.type = ContentViewShadowTypeSurrounding;
    surroudingType.desc = @"SurroundingType";
    surroudingType.thumbnailName = @"surroundingShadow.jpg";
    [types addObject:surroudingType];
    ReflectionShadowType *projectionType = [[ReflectionShadowType alloc] init];
    projectionType.type = ContentViewShadowTypeProjection;
    projectionType.desc = @"ProjectionType";
    projectionType.thumbnailName = @"projectionShadow.jpg";
    [types addObject:projectionType];
    
    return [types copy];
}
@end
