//
//  ReflectionHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/22/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ReflectionHelper.h"
#import "GenericContainerView.h"
#import "ReflectionView.h"
#import "DrawingConstants.h"
#import "UIView+Snapshot.h"
#import "KeyConstants.h"
#import "TextContainerView.h"
@implementation ReflectionHelper

+ (void) applyReflectionViewToGenericContainerView:(GenericContainerView *)container
{
    BOOL showReflection = [[[container attributes] objectForKey:[KeyConstants reflectionKey]] boolValue];
    if (!showReflection) {
        [container.reflection removeFromSuperview];
        container.reflection = nil;
        return;
    }
    if (container.reflection == nil) {
        container.reflection = [[ReflectionView alloc] initWithOriginalView:container];
        [container addSubview:container.reflection];
    }
    container.reflection.hidden = NO;
    [container.reflection updateFrame];
}

+ (void) hideReflectionViewFromGenericContainerView:(GenericContainerView *)container
{
    container.reflection.hidden = YES;
}

+ (UIImage *) reflectionImageForGenericContainerView:(GenericContainerView *) container
{
    UIImage *snapshot = [container contentSnapshot];
    UIGraphicsBeginImageContext(container.reflection.bounds.size);
    CGFloat angle = atan2(container.transform.b, container.transform.a);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x, y;
    if (angle <= M_PI / 2 && angle > 0) {
        x = (container.contentView.bounds.size.height) * sin(angle);
        y = 0;
    } else if (angle < 0 && angle >= - M_PI / 2) {
        x = 0;
        y = -(container.contentView.bounds.size.width) * sin(angle);
    } else if (angle <= M_PI && angle > M_PI / 2) {
        x = container.contentView.bounds.size.height * sin(M_PI - angle) + container.contentView.bounds.size.width * cos(M_PI - angle);
        y = container.contentView.bounds.size.height * cos(M_PI - angle);
    } else if (angle < -M_PI / 2 && angle > - M_PI) {
        x = container.contentView.bounds.size.width * cos(M_PI + angle);
        y = (container.contentView.bounds.size.width * sin(M_PI + angle) + container.contentView.bounds.size.height * cos(M_PI - angle));
    }
    CGContextTranslateCTM(context, x, y);
    CGContextRotateCTM(context, angle);
    CGFloat correctness = 0;
    if ([container isKindOfClass:[TextContainerView class]]) {
        correctness = 2 * [DrawingConstants controlPointRadius];
    }
    CGRect drawingBounds = CGRectMake(0, 0, container.contentView.bounds.size.width + correctness, container.contentView.bounds.size.height + correctness);
    [snapshot drawInRect:drawingBounds];
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
