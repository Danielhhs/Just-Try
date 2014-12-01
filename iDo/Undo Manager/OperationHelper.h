//
//  OperationHelper.h
//  iDo
//
//  Created by Huang Hongsen on 12/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleOperation.h"
#import "CompoundOperation.h"

@interface OperationHelper : NSObject


+ (SimpleOperation *) simpleOperatioWithTargets:(NSArray *) targets
                                            key:(NSString *) key
                                      fromValue:(NSObject *) fromValue
                                        toValue:(NSObject *) toValue;

+ (void) pushSimpleOperationWithTargets:(NSArray *) targets
                                    key:(NSString *) key
                              fromValue:(NSObject *) fromValue
                                toValue:(NSObject *) toValue;

+ (CompoundOperation *) compoundOperationWithSimpleOperations:(NSArray *) simpleOperations;

+ (void) pushCompoundOperationWithSimpleOperations:(NSArray *) simpleOperations;
@end
