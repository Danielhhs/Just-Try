//
//  Proposal+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Proposal.h"

#import "ProposalDTO.h"
@interface Proposal (iDo)
+ (Proposal *) proposalFromAttributes:(ProposalDTO *) attributes
               inManagedObjectContext:(NSManagedObjectContext *) manageObjectContext;

+ (ProposalDTO *) attibutesFromProposal:(Proposal *) proposal;
+ (void) applyProposalAttributes:(ProposalDTO *)proposalAttributes toProposal:(Proposal *) proposal inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;
@end
