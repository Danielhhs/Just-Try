//
//  ImageContentDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "ImageContentDTO.h"

#define DEFAULT_IMAGE_NAME @"background.jpg"
@implementation ImageContentDTO

+ (ImageContentDTO *) defaultImage
{
    ImageContentDTO *imageContent = [[ImageContentDTO alloc] init];
    [GenericContentDTO applyDefaultGenericContentToContentDTO:imageContent];
    imageContent.imageName = DEFAULT_IMAGE_NAME;
    
    UIImage *image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
    CGFloat scale = image.size.width / image.size.height;
    
    CGFloat maxWidth = 1024;
    CGFloat maxHeight = 768;
    CGFloat width, height;
    if (image.size.width > maxWidth && image.size.height > maxHeight) {
        if (image.size.width / maxWidth > image.size.height / maxHeight) {
            width = maxWidth;
            height = width / scale;
        } else {
            height = maxHeight;
            width = height * scale;
        }
    } else if (image.size.width > maxWidth){
        width = maxWidth;
        height = width / scale;
    } else if (image.size.height > maxHeight) {
        height = maxHeight;
        width = height * scale;
    } else {
        width = image.size.width;
        height = image.size.height;
    }
    CGRect bounds = CGRectMake(0, 0, width, height);
    imageContent.bounds = bounds;
    imageContent.center = CGPointMake(512, 384);
    imageContent.contentType = ContentViewTypeImage;
    return imageContent;
}

@end
