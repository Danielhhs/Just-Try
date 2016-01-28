//
//  AnimationPlayer.h
//  iDo
//
//  Created by Huang Hongsen on 1/28/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDTO.h"
#import "PlayingCanvasView.h"
@interface AnimationPlayer : NSObject

+ (AnimationPlayer *)player;

- (void) playAnimation:(AnimationDTO *)animation inCanvas:(PlayingCanvasView *)canvas;

@end
