//
//  UndoManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/2/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"

@protocol UndoManagerDelegate <NSObject>

- (void) disableUndo;
- (void) disableRedo;
- (void) enableUndo;
- (void) enableRedo;

@end

@interface UndoManager : NSObject

+ (UndoManager *) sharedManager;

- (void) setDelegate:(id<UndoManagerDelegate>)delegate;
- (void) pushOperation:(Operation *) operation;
- (void) clearup;
- (void) undo;
- (void) redo;

@end
