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

@implementation Proposal (iDo)

+ (Proposal *) proposalFromAttributes:(NSDictionary *) attributes
               inManagedObjectContext:(NSManagedObjectContext *) manageObjectContext
{
    Proposal *proposal = [NSEntityDescription insertNewObjectForEntityForName:@"Proposal" inManagedObjectContext:manageObjectContext];
    
    [Proposal applyProposalAttributes:attributes toProposal:proposal inManagedObjectContext:manageObjectContext];
    
    return proposal;
}

+ (NSMutableDictionary *) attibutesFromProposal:(Proposal *)proposal
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setObject:proposal.name forKey:[KeyConstants proposalNameKey]];
    [attributes setObject:[UIImage imageWithData:proposal.thumbnail] forKey:[KeyConstants proposalThumbnailKey]];
    NSArray *slides = [proposal.slides sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    
    NSMutableArray *slidesAttributes = [NSMutableArray array];
    
    for (Slide *slide in slides) {
        [slidesAttributes addObject:[Slide attributesFromSlide:slide]];
    }
    [attributes setObject:slidesAttributes forKey:[KeyConstants proposalSlidesKey]];
    
    return attributes;
}

+ (void) applyProposalAttributes:(NSDictionary *)proposalAttributes
                      toProposal:(Proposal *)proposal
          inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    proposal.name = proposalAttributes[[KeyConstants proposalNameKey]];
    UIImage *thumbnail = proposalAttributes[[KeyConstants proposalThumbnailKey]];
    proposal.thumbnail = UIImageJPEGRepresentation(thumbnail, 1.f);
    proposal.currentSelectedSlideIndex = proposalAttributes[[KeyConstants proposalCurrentSelectedSlideKey]];
    NSArray *slidesAttributes = proposalAttributes[[KeyConstants proposalSlidesKey]];
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
