//
//  TransitionEditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TransitionEditMenuView.h"
#import "TransitionEditMenuItem.h"
#import "TextConstants.h"
#define kTransitionEditMenuViewHeight 50
@interface TransitionEditMenuView()
@property (nonatomic, strong) EditMenuItem *transitionInButton;
@property (nonatomic, weak) CanvasView *triggeredCanvas;
@end

@implementation TransitionEditMenuView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _transitionInButton = [[TransitionEditMenuItem alloc] initWithFrame:CGRectMake(0, 0, 0, kTransitionEditMenuViewHeight) title:[TextConstants noneText] editMenu:self action:@selector(handleTransitionIn) hasAnimation:NO];
        self.backgroundColor = [UIColor clearColor];
        self.itemHeight = _transitionInButton.frame.size.height;
    }
    return self;
}

- (NSMutableArray *) availableOperations
{
    return [NSMutableArray arrayWithObject:self.transitionInButton];
}

- (void) handleTransitionIn
{
    self.currentSelectedItem = self.transitionInButton;
    [self.transitionInButton restoreNormalState];
}

- (void) showToCanvas:(CanvasView *)canvas animated:(BOOL)animated
{
    self.triggeredCanvas = canvas;
    self.trigger = canvas;
    [self addSubview:self.transitionInButton];
    self.frame = [self frameFromCurrentButtons];
    [self layoutButtons];
    self.hidden = NO;
    if (animated) {
        self.alpha = 0;
        [UIView animateWithDuration:[DrawingConstants counterGoldenRatio] animations:^{
            self.alpha = 1;
        }];
    }
    [self setNeedsDisplay];
}

- (void) hide
{
    [self removeFromSuperview];
}



@end
