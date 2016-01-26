//
//  ProposalDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "ProposalDTO.h"
#define DEFAULT_PROPOSAL_NAME @"New"
@implementation ProposalDTO

+ (ProposalDTO *) defaultProposal
{
    ProposalDTO *proposal = [[ProposalDTO alloc] init];
    proposal.name = DEFAULT_PROPOSAL_NAME;
    proposal.currentSelectedSlideIndex = 0;
    proposal.slides = [NSMutableArray arrayWithObject:[SlideDTO defaultSlide]];
    return proposal;
}

- (SlideDTO *) currentSlide
{
    if ([self.slides count] > self.currentSelectedSlideIndex) {
        return self.slides[self.currentSelectedSlideIndex];
    } else {
        return nil;
    }
}

- (SlideDTO *) nextSlide
{
    self.currentSelectedSlideIndex++;
    return [self currentSlide];
}
@end
