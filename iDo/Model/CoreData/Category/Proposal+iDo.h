//
//  Proposal+iDo.h
//  iDo
//
//  Created by Huang Hongsen on 11/8/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Proposal.h"

@interface Proposal (iDo)
+ (Proposal *) proposalFromAttributes:(NSDictionary *) attributes
               inManagedObjectContext:(NSManagedObjectContext *) manageObjectContext;

+ (NSDictionary *) attibutesFromProposal:(Proposal *) proposal;
+ (void) applyProposalAttributes:(NSDictionary *)proposalAttributes toProposal:(Proposal *) proposal inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;
@end
