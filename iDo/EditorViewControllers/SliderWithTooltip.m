//
//  SliderWithTooltip.m
//  iDo
//
//  Created by Huang Hongsen on 10/24/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SliderWithTooltip.h"
#import "UndoManager.h"
#import "SimpleOperation.h"

#define THUMB_RADIUS 5

@interface SliderWithTooltip()<OperationTarget>
@property (nonatomic, strong) SimpleOperation *operation;
@end

@implementation SliderWithTooltip

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.operation = [[SimpleOperation alloc] initWithTargets:@[self.target, self] key:self.key fromValue:@(self.value)];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self finishTouching];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self finishTouching];
}

- (void) finishTouching
{
    self.operation.toValue = @(self.value);
    [[UndoManager sharedManager] pushOperation:self.operation];
    [self.delegate touchDidEndInSlider:self];
}

#pragma mark - Operation Target
- (void) performOperation:(Operation *)operation
{
    if ([operation isKindOfClass:[SimpleOperation class]]) {
        SimpleOperation *simpleOperation = (SimpleOperation *)operation;
        self.value = [((NSNumber *)simpleOperation.toValue) doubleValue];
    }
}

- (SimpleOperation *) setValue:(float)value generateOperations:(BOOL)generateOperations
{
    SimpleOperation *operation = nil;
    if (generateOperations) {
        operation = [[SimpleOperation alloc] initWithTargets:@[self] key:self.key fromValue:@(self.value)];
        operation.toValue = @(value);
    }
    [self setValue:value animated:YES];
    return operation;
}

@end
