//
//  ProposalAttributesManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ProposalAttributesManager.h"
#import "KeyConstants.h"
#import "Proposal+iDo.h"
#import "CoreDataManager.h"
static ProposalAttributesManager *sharedInstance;

@implementation ProposalAttributesManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (ProposalAttributesManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[ProposalAttributesManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Slides Management
- (void) addNewSlideToProposal:(ProposalDTO *) proposal atIndex:(NSInteger) index
{
    [self addSlide:[SlideDTO defaultSlide] toProposal:proposal atIndex:index];
}

- (void) addSlide:(SlideDTO *) slide toProposal:(ProposalDTO *)proposal atIndex:(NSInteger)index
{
    [proposal.slides insertObject:slide atIndex:index];
    proposal.currentSelectedSlideIndex = index;
}

- (void) saveSlide:(SlideDTO *)slide toProposal:(ProposalDTO *)proposal
{
    SlideDTO *originalSlide = [self findOriginalSlideForSlide:slide inProposal:proposal];
    [originalSlide mergeChangedPropertiesFromSlide:slide];
//    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:proposal];
}

- (SlideDTO *) findOriginalSlideForSlide:(SlideDTO *)slide inProposal:(ProposalDTO *) proposal
{
    for (SlideDTO *slideInProposal in proposal.slides) {
        if (slide.unique == slideInProposal.unique) {
            return slideInProposal;
        }
    }
    return nil;
}

@end
