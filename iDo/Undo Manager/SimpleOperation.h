//
//  SimpleOperation.h
//  iDo
//
//  Created by Huang Hongsen on 11/3/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "Operation.h"

@interface SimpleOperation : Operation


@property (nonatomic, strong) id<OperationTarget> target;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSObject *fromValue;
@property (nonatomic, strong) NSObject *toValue;

- (instancetype) initWithTarget:(NSObject *) target
                            key:(NSString *) key
                      fromValue:(NSObject *) fromValue;

@end
