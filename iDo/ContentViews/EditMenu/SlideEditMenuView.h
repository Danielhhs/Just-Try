//
//  SlideEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuView.h"
#import "CanvasView.h"

@interface SlideEditMenuView : EditMenuView
@property (nonatomic, weak) CanvasView *triggeredCanvas;
- (void) showToCanvas:(CanvasView *) canvas animated:(BOOL) animated;
@end
