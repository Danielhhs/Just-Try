//
//  ImageHelper.h
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject
+ (UIImage *) blurredImageWithSourceImage:(UIImage *) image
                                   inRect:(CGRect) rect;
@end
