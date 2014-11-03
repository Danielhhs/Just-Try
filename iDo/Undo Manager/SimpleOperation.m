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

- (instancetype) initWithTarget:(id<OperationTarget>)target
                            key:(NSString *)key
                      fromValue:(NSObject *)fromValue
{
    self = [super init];
    if (self) {
        _target = target;
        _key = key;
        _fromValue = fromValue;
        _toValue = nil;
    }
    return self;
}

- (Operation *) reverseOperation
{
    NSString *key = self.key;
    if ([self.key isEqualToString:[KeyConstants addKey]]) {
        key = [KeyConstants deleteKey];
    } else if ([self.key isEqualToString:[KeyConstants deleteKey]]) {
        key = [KeyConstants addKey];
    }
    SimpleOperation *reverse = [[SimpleOperation alloc] initWithTarget:self.target key:self.key fromValue:self.toValue];
    reverse.toValue = self.fromValue;
    return reverse;
}

- (void) makeTargetPerformReverseOperation
{
    [self.target performOperation:[self reverseOperation]];
}

- (void) makeTargetPerformOperation
{
    [self.target performOperation:self];
}

@end
