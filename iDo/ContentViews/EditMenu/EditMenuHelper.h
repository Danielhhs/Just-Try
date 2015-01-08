//
//  EditMenuHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/18/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericContainerView.h"
@interface EditMenuHelper : NSObject

+ (NSData *) encodeGenericContent:(GenericContainerView *)content;

+ (GenericContentDTO *) decodeGenericContentFromData:(NSData *) data;

@end
