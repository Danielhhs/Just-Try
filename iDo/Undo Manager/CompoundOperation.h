//
//  CompoundOperation.h
//  iDo
//
//  Created by Huang Hongsen on 11/3/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Operation.h"
#import "SimpleOperation.h"

@interface CompoundOperation : Operation

- (instancetype) initWithTargets:(NSArray *) targets
                            keys:(NSArray *) keys
                      fromValues:(NSArray *) fromValues;

- (instancetype) initWithOperations:(NSArray *) operations;

- (void) setToValues:(NSArray *) toValues;

@end
