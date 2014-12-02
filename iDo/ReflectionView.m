//
//  ReflectionView.m
//  iDo
//
//  Created by Huang Hongsen on 10/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ReflectionView.h"
#import "UIView+Snapshot.h"
#import "GenericContainerViewHelper.h"
#import "DrawingConstants.h"
#import "ReflectionHelper.h"
#import "TextContainerView.h"

#define REFLECTION_HEIGHT_WIDTH_RATIO 0.2
#define REFLECTION_GAP_INSET_IMAGE 20
#define REFLECTION_GAP_INSET_TEXT 40

@implementation ReflectionView

- (instancetype) initWithOriginalView:(GenericContainerView *) originalView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _originalView = originalView;
        _height = [DrawingConstants counterGoldenRatio];
        _image = [self reflectedImage:originalView withHeight:self.bounds.size.height * [DrawingConstants counterGoldenRatio]];
    }
    return self;
}

- (void) updateReflectionWithWithReflectionHeight:(CGFloat) reflectionHeight
{
    if (self.hidden == NO) {
        self.image = [self reflectedImage:self.originalView withHeight:self.bounds.size.height * reflectionHeight];
    }
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (void) setHeight:(CGFloat)height
{
    _height = height;
    self.image = [self reflectedImage:self.originalView withHeight:self.bounds.size.height * height];
}

- (void) updateFrame
{
    self.transform = CGAffineTransformInvert(self.originalView.transform);
    CGFloat angel = atan2(self.originalView.transform.b, self.originalView.transform.a);
    CGFloat correctness = MAX(ABS(cos(angel)), ABS(sin(angel)));
    CGFloat inset = [DrawingConstants controlPointSizeHalf] / correctness;
    self.bounds = CGRectMake(0, 0, self.originalView.frame.size.width - 2 * inset, self.originalView.frame.size.height - 2 * inset);
    CGFloat centerY = self.originalView.center.y + self.originalView.frame.size.height - [self reflectionGapInset];
    self.center = [self.originalView convertPoint:CGPointMake(self.originalView.center.x, centerY) fromView:self.originalView.superview];
    [self updateReflectionWithWithReflectionHeight:self.height];
}

- (CGFloat) reflectionGapInset
{
    if ([self.originalView isKindOfClass:[TextContainerView class]]) {
        return REFLECTION_GAP_INSET_TEXT;
    } else {
        return REFLECTION_GAP_INSET_IMAGE;
    }
}

- (void) drawRect:(CGRect)rect
{
    [self.image drawAtPoint:CGPointZero];
}

CGImageRef CreateGradientImage(NSInteger pixelsWide, NSInteger pixelsHigh)
{
    CGImageRef image = NULL;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
                                                               8, 0, colorspace, kCGBitmapByteOrderDefault);
    
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorspace, colors, NULL, 2);
    CGColorSpaceRelease(colorspace);
    
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
    
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation );
    CGGradientRelease(grayScaleGradient);
    
    image = CGBitmapContextCreateImage(gradientBitmapContext);
    return image;
}

CGContextRef CreateBitMapContext(NSInteger pixelsWide, NSInteger pixelsHigh) {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, 0, colorspace, kCGBitmapByteOrder32Little| kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorspace);
    return bitmapContext;
}

- (UIImage *) reflectedImage:(GenericContainerView *)fromImage withHeight:(NSInteger) height
{
    if (height == 0) return nil;
    
    CGContextRef mainViewContentContext = CreateBitMapContext(self.bounds.size.width, height);
    
    CGImageRef gradientImage = CreateGradientImage(1, height);
    
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, self.bounds.size.width, height), gradientImage);
    CGImageRelease(gradientImage);
    
    CGContextTranslateCTM(mainViewContentContext, 0, height);
    CGContextScaleCTM(mainViewContentContext, 1, -1);
    
    CGRect drawingBounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGContextDrawImage(mainViewContentContext, drawingBounds, [ReflectionHelper reflectionImageForGenericContainerView:self.originalView].CGImage);
        
    CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *image = [UIImage imageWithCGImage:reflectionImage];
    
    CGImageRelease(reflectionImage);
    return image;
    
}

@end
