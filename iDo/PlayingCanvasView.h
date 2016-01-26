//
//  PlayingCanvasView.h
//  iDo
//
//  Created by Huang Hongsen on 1/25/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "CanvasView.h"
@class PlayingCanvasView;
@protocol PlayingCanvasViewDelegate<CanvasViewDelegate>
- (void) playingCanvasViewDidFinishPlaying:(PlayingCanvasView *)canvas;
@end

@interface PlayingCanvasView : CanvasView

@property (nonatomic, weak) id<PlayingCanvasViewDelegate> delegate;
- (void) playNextAnimation;

@end
