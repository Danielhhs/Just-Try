//
//  PlayingCanvasView.m
//  iDo
//
//  Created by Huang Hongsen on 1/25/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "PlayingCanvasView.h"
#import "AnimationDTO.h"
#import "GenericContainerViewHelper.h"
@interface PlayingCanvasView ()<AnimationDelegate>
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic) NSInteger currentAnimationIndex;
@end

@implementation PlayingCanvasView
@dynamic delegate;
#pragma mark - Set up
- (void) setupWithAttributes:(SlideDTO *)attributes
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[GenericContainerView class]]) {
            [subview removeFromSuperview];
        }
    }
    UIImage *background = [UIImage imageNamed:attributes.backgroundImage];
    self.layer.contents = (__bridge id)background.CGImage;
    for (GenericContentDTO *content in attributes.contents) {
        GenericContainerView *contentView = [GenericContainerViewHelper contentViewFromAttributes:content delegate:nil];
        contentView.canvas = self;
        contentView.userInteractionEnabled = NO;
        [self.contents addObject:contentView];
        BOOL showContentOnAppear = [content shouldShowOnPlayingCanvasAppear];
        if (showContentOnAppear) {
            [self addSubview:contentView];
            [contentView contentHasBeenAddedToSuperView];
        }
        for (AnimationDTO *animation in content.animations) {
            animation.target = contentView;
            [self.animations addObject:animation];
        }
    }
    [self.animations sortUsingComparator:^NSComparisonResult(AnimationDTO * obj1, AnimationDTO * obj2) {
        return obj1.index > obj2.index;
    }];
    [self disablePinch];
    self.currentAnimationIndex = 0;
    NSLog(@"Animations: %@", self.animations);
}

#pragma mark - Lazy Instantiation
- (NSMutableArray *) contents
{
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}

- (NSMutableArray *) animations
{
    if (!_animations) {
        _animations = [NSMutableArray array];
    }
    return _animations;
}

#pragma mark - Play Animation
- (void) playNextAnimation
{
    if ([self.animations count] > self.currentAnimationIndex) {
        AnimationDTO *animation = self.animations[self.currentAnimationIndex];
        animation.delegate = self;
        [animation performSelector:@selector(playInCanvas:) withObject:self afterDelay:animation.triggeredTime];
    } else {
        [self.delegate playingCanvasViewDidFinishPlaying:self];
    }
}

- (void) animationDidFinsihPlaying
{
    self.currentAnimationIndex++;
    [self playNextAnimation];
}

@end
