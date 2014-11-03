//
//  SimpleOperation.m
//  iDo
//
//  Created by Huang Hongsen on 11/3/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SimpleOperation.h"
#import "KeyConstants.h"
@implementation SimpleOperation

- (instancetype) initWithTargets:(NSArray *)target
                             key:(NSString *)key
                       fromValue:(NSObject *)fromValue
{
    self = [super init];
    if (self) {
        _targets = target;
        _key = key;
        _fromValue = fromValue;
        _toValue = nil;
    }
    return self;
}

- (void) setToValue:(NSObject *)toValue
{
    _toValue = toValue;
}

- (SimpleOperation *) reverseOperation
{
    NSString *key = self.key;
    if ([self.key isEqualToString:[KeyConstants addKey]]) {
        key = [KeyConstants deleteKey];
    } else if ([self.key isEqualToString:[KeyConstants deleteKey]]) {
        key = [KeyConstants addKey];
    }
    SimpleOperation *reverse = [[SimpleOperation alloc] initWithTargets:self.targets key:self.key fromValue:self.toValue];
    reverse.toValue = self.fromValue;
    return reverse;
}

- (void) makeTargetPerformReverseOperation
{
    for (id<OperationTarget> target in self.targets) {
        [target performOperation:(SimpleOperation *)[self reverseOperation]];
    }
}

- (void) makeTargetPerformOperation
{
    for (id<OperationTarget> target in self.targets) {
        [target performOperation:self];
    }
}

@end
