//
//  SimpleOperation.h
//  iDo
//
//  Created by Huang Hongsen on 11/3/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Operation.h"

@interface SimpleOperation : Operation

@property (nonatomic, strong) NSArray *targets;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSObject *fromValue;
@property (nonatomic, strong) NSObject *toValue;
@property (nonatomic, strong) NSObject *container;

- (instancetype) initWithTargets:(NSArray *) targets
                             key:(NSString *) key
                       fromValue:(NSObject *) fromValue;

- (void) setToValue:(NSObject *)toValue;
@end
