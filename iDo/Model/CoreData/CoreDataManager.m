//
//  CoreDataHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
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
    if (self) {
        [self createOrOpenDataModel];
    }
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
+ (NSManagedObjectContext *) databaseContext
{
    return sharedInstance.document.managedObjectContext;
}

#pragma mark - Managed Document
- (void) createOrOpenDataModel
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
        
    }
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
