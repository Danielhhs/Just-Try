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

#define REFLECTION_HEIGHT_WIDTH_RATIO 0.2
#define SPACE_BETWEEN_REFLECTION 7

@implementation ReflectionView

- (instancetype) initWithOriginalView:(GenericContainerView *) originalView
{
    CGRect frame = [self reflectionViewFrameFromOriginalView:originalView];
    self = [super initWithFrame:frame];
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

- (CGRect) reflectionViewFrameFromOriginalView:(GenericContainerView *) originalView
{
    return CGRectOffset([originalView contentViewFrameFromBounds:originalView.bounds], 0, [originalView contentViewFrameFromBounds:originalView.bounds].size.height - CONTROL_POINT_RADIUS + SPACE_BETWEEN_REFLECTION);
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
    self.frame = [self reflectionViewFrameFromOriginalView:self.originalView];
    [self updateReflectionWithWithReflectionHeight:self.height];
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
    
    CGContextRef mainViewContentContext = CreateBitMapContext([fromImage contentViewFrameFromBounds:fromImage.bounds].size.width, height);
    
    CGImageRef gradientImage = CreateGradientImage(1, height);
    
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, [fromImage contentViewFrameFromBounds:fromImage.bounds].size.width, height), gradientImage);
    CGImageRelease(gradientImage);
    
    CGContextTranslateCTM(mainViewContentContext, 0, height);
    CGContextScaleCTM(mainViewContentContext, 1, -1);
    
    CGRect drawingBounds = CGRectMake(0, 0, [fromImage contentViewFrameFromBounds:fromImage.bounds].size.width, [fromImage contentViewFrameFromBounds:fromImage.bounds].size.height);
    CGContextDrawImage(mainViewContentContext, drawingBounds, [fromImage contentSnapshot].CGImage);
        
    CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *image = [UIImage imageWithCGImage:reflectionImage];
    
    CGImageRelease(reflectionImage);
    return image;
    
}

@end
