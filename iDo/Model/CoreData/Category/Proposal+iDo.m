//
//  Proposal+iDo.m
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Proposal+iDo.h"
#import <UIKit/UIKit.h>
#import "KeyConstants.h"
#import "Slide+iDo.h"
#import "SlideDTO.h"
@implementation Proposal (iDo)

+ (Proposal *) proposalFromAttributes:(ProposalDTO *) attributes
               inManagedObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    Proposal *proposal = [NSEntityDescription insertNewObjectForEntityForName:@"Proposal" inManagedObjectContext:manageObjectContext];
    
    [Proposal applyProposalAttributes:attributes toProposal:proposal inManagedObjectContext:manageObjectContext];
    
    return proposal;
}

+ (ProposalDTO *) attibutesFromProposal:(Proposal *)proposal
{
    ProposalDTO *attributes = [[ProposalDTO alloc] init];
    
    attributes.name = proposal.name;
    attributes.thumbnail = [UIImage imageWithData:proposal.thumbnail];
    NSArray *slides = [proposal.slides sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    NSMutableArray *slidesAttribute = [NSMutableArray array];
    for (Slide *slide in slides) {
        [slidesAttribute addObject:[Slide attributesFromSlide:slide]];
    }
    attributes.slides = slidesAttribute;
    attributes.currentSelectedSlideIndex = [proposal.currentSelectedSlideIndex integerValue];
    return attributes;
}

+ (void) applyProposalAttributes:(ProposalDTO *)proposalAttributes
                      toProposal:(Proposal *)proposal
          inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    proposal.name = proposalAttributes.name;
    UIImage *thumbnail = proposalAttributes.thumbnail;
    proposal.thumbnail = UIImageJPEGRepresentation(thumbnail, 1.f);
    proposal.currentSelectedSlideIndex = @(proposalAttributes.currentSelectedSlideIndex);
    NSArray *slidesAttributes = proposalAttributes.slides;
    NSArray *slides = [proposal.slides sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    for (NSInteger i = 0; i < [slidesAttributes count];  i++) {
        Slide *slide = nil;
        if ([slides count] <= i) {
            slide = [Slide slideFromAttributes:slidesAttributes[i] inManagedObjectContext:managedObjectContext];
        } else {
            slide = slides[i];
            [Slide applySlideAttributes:slidesAttributes[i] toSlide:slide inManageObjectContext:managedObjectContext];
        }
        slide.index = @(i);
        [proposal addSlidesObject:slide];
    }
    
}

@end
