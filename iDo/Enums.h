//
//  Enums.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationConstants.h"

typedef NS_ENUM(NSInteger, ContentViewShadowType) {
    ContentViewShadowTypeOffset = 0,
    ContentViewShadowTypeSurrounding = 1,
    ContentViewShadowTypeProjection = 2,
    ContentViewShadowTypeStereo = 3,
    ContentViewShadowTypeNone = 4,
};

typedef NS_ENUM(NSUInteger, ContentViewType) {
    ContentViewTypeImage = 0,
    ContentViewTypeText = 1,
    ContentViewTypeVideo = 2
};
@interface Enums : NSObject

@end
