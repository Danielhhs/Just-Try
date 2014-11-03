//
//  CompoundOperation.m
//  iDo
//
//  Created by Huang Hongsen on 11/3/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CompoundOperation.h"
#import "SimpleOperation.h"

@interface CompoundOperation ()
@property (nonatomic, strong) NSMutableArray *operations;
@end

@implementation CompoundOperation
- (instancetype) initWithTargets:(NSArray *)targets keys:(NSArray *)keys fromValues:(NSArray *)fromValues
{
    self = [super init];
    if (self) {
        if ([targets count] != [keys count] || [keys count] != [fromValues count]) {
            return nil;
        }
        self.operations = [NSMutableArray array];
        for (NSInteger i = 0; i < [targets count]; i++) {
            SimpleOperation *simpleOperation = [[SimpleOperation alloc] initWithTarget:targets[i] key:keys[i] fromValue:fromValues[i]];
            [self.operations addObject:simpleOperation];
        }
    }
    return self;
}

- (instancetype) initWithOperations:(NSArray *)operations
{
    self = [super init];
    if (self) {
        self.operations = [NSMutableArray array];
        for (Operation *operation in operations) {
            [self.operations addObject:operation];
        }
    }
    return self;
}

- (void) setToValues:(NSArray *)toValues{
    if ([toValues count] != [self.operations count]) {
        return;
    }
    for (NSInteger i = 0; i < [self.operations count]; i++) {
        SimpleOperation *operation = self.operations[i];
        operation.toValue = toValues[i];
    }
}

- (CompoundOperation *) reverseOperation
{
    NSMutableArray *reversOperations = [NSMutableArray array];
    for (Operation *operation in self.operations) {
        [reversOperations insertObject:[operation reverseOperation] atIndex:0];
    }
    CompoundOperation *reverse = [[CompoundOperation alloc] initWithOperations:reversOperations];
    return reverse;
}

- (void) makeTargetPerformOperation
{
    for (Operation *operation in self.operations) {
        [operation makeTargetPerformOperation];
    }
}

- (void) makeTargetPerformReverseOperation
{
    for (Operation *operation in self.operations) {
        [operation makeTargetPerformReverseOperation];
    }
}


@end
