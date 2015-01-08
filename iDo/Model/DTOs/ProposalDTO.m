//
//  ProposalDTO.m
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "ProposalDTO.h"
#import "SlideDTO.h"
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
@end
