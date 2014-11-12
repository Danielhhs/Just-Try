//
//  SlideAttributesManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanvasView.h"

@interface SlideAttributesManager : NSObject

+ (SlideAttributesManager *) sharedManager;

- (void) addNewContent:(NSMutableDictionary *) content toSlide:(NSMutableDictionary *) slide;

- (void) saveCanvasContents:(CanvasView *)canvas toSlide:(NSMutableDictionary *) slide;

@end
