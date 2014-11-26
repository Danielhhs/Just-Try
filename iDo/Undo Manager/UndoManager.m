//
//  UndoManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "UndoManager.h"
@interface UndoManager()
@property (nonatomic, strong) NSMutableArray *undoStack;    //Of Operations
@property (nonatomic) NSUInteger cursor;
@property (nonatomic, weak) id<UndoManagerDelegate> delegate;
@end

static UndoManager *sharedInstance = nil;
@implementation UndoManager

#pragma mark - Singleton
+ (UndoManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[UndoManager alloc] initInternal];
    }
    return sharedInstance;
}

- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        _undoStack = [NSMutableArray array];
        _cursor = 0;
    }
    return self;
}

#pragma mark - Operations

- (void) clearup
{
    [self.undoStack removeAllObjects];
    self.cursor = 0;
}

- (void) pushOperation:(Operation *)operation
{
    if (self.cursor != [self.undoStack count]) {
        [self.undoStack removeObjectsInRange:NSMakeRange(self.cursor, [self.undoStack count] - self.cursor)];
    }
    [self.undoStack addObject:operation];
    self.cursor++;
}

- (void) undo
{
    if (self.cursor > 0) {
        self.cursor--;
        Operation *operation = self.undoStack[self.cursor];
        [operation makeTargetPerformReverseOperation];
    }
}

- (void) redo
{
    if (self.cursor < [self.undoStack count]) {
        Operation *operation = self.undoStack[self.cursor];
        self.cursor++;
        [operation makeTargetPerformOperation];
    }
}

- (void) setDelegate:(id<UndoManagerDelegate>)delegate
{
    _delegate = delegate;
}

- (void) setCursor:(NSUInteger)cursor
{
    if (cursor == 0) {
        [self.delegate disableUndo];
    } else if (cursor == [self.undoStack count]) {
        [self.delegate disableRedo];
    }
    if (cursor != 0 && _cursor == 0) {
        [self.delegate enableUndo];
    } else if (cursor != [self.undoStack count] && _cursor == [self.undoStack count]) {
        [self.delegate enableRedo];
    }
    _cursor = cursor;
}

- (void) clearRedoStack
{
    if ([self.undoStack count] > self.cursor) {
        [self.undoStack removeObjectsInRange:NSMakeRange(self.cursor, [self.undoStack count] - self.cursor)];
    }
}

- (void) clearUndoStack
{
    self.undoStack = [NSMutableArray array];
    self.cursor = 0;
}

@end
