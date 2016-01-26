//
//  SlidesPlayViewController.m
//  iDo
//
//  Created by Huang Hongsen on 1/25/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import "SlidesPlayViewController.h"
#import "PlayingCanvasView.h"
#import "SlideDTO.h"
#import "UIView+Snapshot.h"
@interface SlidesPlayViewController ()<PlayingCanvasViewDelegate>

@property (nonatomic, strong) PlayingCanvasView *currentCanvas;
@property (nonatomic, strong) PlayingCanvasView *nextCanvas;
@property (nonatomic) NSInteger initialSlideIndex;
@end

@implementation SlidesPlayViewController

#pragma mark - ViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) setProposal:(ProposalDTO *)proposal
{
    _proposal = proposal;
    self.initialSlideIndex = proposal.currentSelectedSlideIndex;
    [self prepareContentForPlayMode];
}

- (CGRect) canvasFrame
{
    return self.currentCanvas.frame;
}

- (UIImage *) canvasSnapshot
{
    return [self.currentCanvas snapshot];
}

#pragma mark - PlayMode Preparation
- (void) prepareContentForPlayMode
{
    SlideDTO *currentSlide = [self.proposal currentSlide];
    self.currentCanvas = [[PlayingCanvasView alloc] initWithSlideAttributes:currentSlide delegate:nil contentDelegate:nil];
    self.currentCanvas.delegate = self;
    [self.view addSubview:self.currentCanvas];
}

- (void) startPlaying
{
    [self.currentCanvas playNextAnimation];
}

#pragma mark - CanvasViewDelegate
- (void) userDidTapInCanvas:(CanvasView *)canvas
{
    [self cancelPlayingMode];
}

- (void) playingCanvasViewDidFinishPlaying:(PlayingCanvasView *)canvas
{
    SlideDTO *nextSlide = [self.proposal nextSlide];
    if (nextSlide) {
        self.nextCanvas = [[PlayingCanvasView alloc] initWithSlideAttributes:nextSlide delegate:nil contentDelegate:nil];
        self.nextCanvas.delegate = self;
        [self.currentCanvas removeFromSuperview];
        [self.view addSubview:self.nextCanvas];
        self.currentCanvas = self.nextCanvas;
        self.nextCanvas = nil;
        [self.currentCanvas playNextAnimation];
    } else {
        [self cancelPlayingMode];
        self.proposal.currentSelectedSlideIndex = self.initialSlideIndex;
    }
}

- (void) cancelPlayingMode
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
