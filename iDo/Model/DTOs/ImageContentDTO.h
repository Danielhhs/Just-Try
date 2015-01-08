//
//  ImageContentDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "GenericContentDTO.h"

@interface ImageContentDTO : GenericContentDTO
@property (nonatomic) NSString *imageName;
+ (ImageContentDTO *) defaultImage;
@end
