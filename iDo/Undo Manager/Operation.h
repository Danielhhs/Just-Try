//
//  Operation.h
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleOperation;

@protocol OperationTarget <NSObject>

- (void) performOperation:(SimpleOperation *) operation;

@end

@interface Operation : NSObject

- (Operation *) reverseOperation;

- (void) makeTargetPerformOperation;
- (void) makeTargetPerformReverseOperation;
@end
