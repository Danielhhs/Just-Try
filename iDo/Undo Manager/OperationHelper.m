//
//  OperationHelper.m
//  iDo
//
//  Created by Huang Hongsen on 12/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "OperationHelper.h"
#import "UndoManager.h"

@implementation OperationHelper

+ (SimpleOperation *) simpleOperatioWithTargets:(NSArray *)targets key:(NSString *)key fromValue:(NSObject *)fromValue toValue:(NSObject *)toValue
{
    SimpleOperation *operation = [[SimpleOperation alloc] initWithTargets:targets key:key fromValue:fromValue];
    operation.toValue = toValue;
    return operation;
}

+ (void) pushSimpleOperationWithTargets:(NSArray *)targets key:(NSString *)key fromValue:(NSObject *)fromValue toValue:(NSObject *)toValue
{
    SimpleOperation *operaiton = [OperationHelper simpleOperatioWithTargets:targets key:key fromValue:fromValue toValue:toValue];
    [[UndoManager sharedManager] pushOperation:operaiton];
}

+ (CompoundOperation *) compoundOperationWithSimpleOperations:(NSArray *)simpleOperations
{
    CompoundOperation *operation = [[CompoundOperation alloc] initWithOperations:simpleOperations];
    return operation;
}

+ (void) pushCompoundOperationWithSimpleOperations:(NSArray *)simpleOperations
{
    CompoundOperation *operation = [OperationHelper compoundOperationWithSimpleOperations:simpleOperations];
    [[UndoManager sharedManager] pushOperation:operation];
}
@end
