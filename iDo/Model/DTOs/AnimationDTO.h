//
//  AnimationDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"
#import "Enums.h"
@class GenericContainerView;
@class PlayingCanvasView;

@protocol AnimationDelegate <NSObject>

- (void) animationDidFinsihPlaying;

@end

@interface AnimationDTO : DataTransferObject<NSCoding>
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimationEffect effect;
@property (nonatomic) NSTimeInterval triggeredTime;
@property (nonatomic) NSInteger index;
@property (nonatomic) AnimationPermittedDirection direction;
@property (nonatomic) AnimationEvent event;
@property (nonatomic, strong) NSUUID *contentUUID;
@property (nonatomic, weak) GenericContainerView *target;
@property (nonatomic, weak) id<AnimationDelegate> delegate;
- (void) playInCanvas:(PlayingCanvasView *)canvas;
@end
