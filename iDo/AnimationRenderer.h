//
//  AnimationRenderer.h
//  iDo
//
//  Created by Huang Hongsen on 1/26/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDTO.h"
#import "PlayingCanvasView.h"
@interface AnimationRenderer : NSObject
@property (nonatomic, strong) void(^completion)(void);
- (void) animateObject:(AnimationDTO *)animation inCanvas:(PlayingCanvasView *)canvas completion:(void(^)(void))completion;

@end
