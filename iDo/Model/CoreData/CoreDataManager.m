//
//  CoreDataHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import <UIKit/UIKit.h>
#import "DefaultValueGenerator.h"
#import "Proposal+iDo.h"
@interface CoreDataManager()
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSArray *proposals;
@property (nonatomic, strong) Proposal *currentProposal;
@end

static CoreDataManager *sharedInstance;

@implementation CoreDataManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    return self;
}

+ (CoreDataManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[CoreDataManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Public APIs
- (NSManagedObjectContext *) databaseContext
{
    return sharedInstance.document.managedObjectContext;
}

- (void) setSelectedProposalIndex:(NSInteger)index
{
    self.currentProposal = self.proposals[index];
}

#pragma mark - Managed Document
- (void) openDataModelAndLoadProposals
{
    self.document = [[UIManagedDocument alloc] initWithFileURL:[self modelURL]];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:[self modelURL].path];
    if (fileExist) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self documentIsReady];
        }];
    } else {
        [self.document saveToURL:[self modelURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self documentIsReady];
        }];
    }
}

- (void) documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        [self loadProposals];
    }
}

- (void) loadProposals
{
    self.proposals = [CoreDataHelper loadAllProposalsFromManagedObjectContext:self.document.managedObjectContext];
    NSMutableArray *proposalAttribtues = [NSMutableArray array];
    for (Proposal *proposal in self.proposals) {
        [proposalAttribtues addObject:[Proposal attibutesFromProposal:proposal]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate managerFinishLoadingProposals:proposalAttribtues];
    });
}

- (void) saveProposalWithProposalChanges:(NSDictionary *)proposalChanges
{
    [Proposal applyProposalAttributes:proposalChanges toProposal:self.currentProposal inManagedObjectContext:self.document.managedObjectContext];
    [self saveDocument];
}

- (NSMutableDictionary *) createNewProposal
{
    Proposal *proposal = [Proposal proposalFromAttributes:[DefaultValueGenerator defaultProposalAttributes] inManagedObjectContext:self.document.managedObjectContext];
    self.currentProposal = proposal;
    return [Proposal attibutesFromProposal:proposal];
}

- (NSURL *) modelURL
{
    return [[self documentsURL] URLByAppendingPathComponent:@"iDoDataModel"];
}

- (NSURL *) documentsURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) saveDocument
{
    [self.document saveToURL:[self modelURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        NSLog(@"Sucess = %d", success);
        [self loadProposals];
    }];
}

@end
