//
//  CoreDataHelper.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Proposal;
@protocol CoreDataManagerDelegate <NSObject>

- (void) managerFinishLoadingProposals:(NSArray *) proposals;

@end

@interface CoreDataManager : NSObject

@property (nonatomic, weak) id<CoreDataManagerDelegate> delegate;

+ (CoreDataManager *) sharedManager;

- (NSManagedObjectContext *) databaseContext;
- (void) openDataModelAndLoadProposals;
- (void) saveProposalWithProposalChanges:(NSDictionary *) proposalChanges;
- (NSMutableDictionary *) createNewProposal;
- (void) setSelectedProposalIndex:(NSInteger)index;
@end
