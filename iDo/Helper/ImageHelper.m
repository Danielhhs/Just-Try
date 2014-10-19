//
//  ImageHelper.m
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *) blurredImageWithSourceImage:(UIImage *) image
                                   inRect:(CGRect) rect
{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey:@"inputImage"];
    [gaussianBlurFilter setValue:@30 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef imageRef = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(outputContext, 1., -1.);
    CGContextTranslateCTM(outputContext, 0, -rect.size.height);
    
    CGContextDrawImage(outputContext, rect, imageRef);
    
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, rect);
    CGContextRestoreGState(outputContext);
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
    
}

@end
