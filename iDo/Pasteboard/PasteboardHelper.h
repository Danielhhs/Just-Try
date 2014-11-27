//
//  PasteboardHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/27/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PasteboardHelper : NSObject

+ (void) clearPasteboard;

+ (void) copyData:(NSData *) data;

+ (NSData *) dataFromPasteboard;

@end
