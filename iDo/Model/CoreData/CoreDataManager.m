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
    NSArray *proposals = [CoreDataHelper loadAllProposalsFromManagedObjectContext:self.document.managedObjectContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate managerFinishLoadingProposals:proposals];
    });
}

- (void) saveProposalWithProposalChanges:(NSDictionary *)proposalChanges
{
//    [Proposal applyProposalAttributes:proposalAttributes toProposal:self.currentProposal];
    [self saveDocument];
    [self loadProposals];
}

- (void) createNewProposal
{
    Proposal *proposal = [Proposal proposalFromAttributes:[DefaultValueGenerator defaultProposalAttributes] inManagedObjectContext:self.document.managedObjectContext];
    self.currentProposal = proposal;
    [self saveDocument];
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
        
    }];
}

@end
