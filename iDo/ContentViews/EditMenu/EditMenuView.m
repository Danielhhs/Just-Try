//
//  EditMenuView.m
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuView.h"
#import "EditMenuItem.h"
#import "CanvasView.h"
#import "GenericContainerView.h"
@interface EditMenuView()
@end

#define EDIT_MENU_ARROW_HEIGHT 10
@implementation EditMenuView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.availableOperations = [NSMutableArray array];
        self.separatorLocations = [NSMutableArray array];
    }
    return self;
}

- (CGRect) frameFromCurrentButtons
{
    CGRect frame;
    frame.size.width = 0;
    for (EditMenuItem *item in self.availableOperations) {
        CGFloat increment = item.bounds.size.width + SEPARATOR_WIDTH;
        frame.size.width += increment;
    }
    frame.size.height = self.itemHeight + EDIT_MENU_ARROW_HEIGHT;
    frame.origin.y = self.trigger.frame.origin.y - self.itemHeight;
    frame.origin.x = self.trigger.center.x - self.bounds.size.width / 2;
    return frame;
}

- (void) update
{
    if (self.hidden == NO) {
        self.frame = [self frameFromCurrentButtons];
    }
}

- (void) layoutButtons
{
    [self.separatorLocations removeAllObjects];
    CGFloat currentLocation = 0;
    for (EditMenuItem *item in self.availableOperations) {
        item.center = CGPointMake(currentLocation + CGRectGetMidX(item.bounds), CGRectGetMidY(item.bounds));
        currentLocation = currentLocation + CGRectGetMaxX(item.bounds) + SEPARATOR_WIDTH;
        [self.separatorLocations addObject:@(currentLocation - SEPARATOR_WIDTH)];
    }
    [self.separatorLocations removeLastObject];
}

- (void) hide
{
}

- (EditMenuItemType) itemTypeForButtonItem:(EditMenuItem *) item index:(NSInteger) index totalItems:(NSInteger) totalItems {
    if (totalItems == 1) {
        return EditMenuItemTypeOnly;
    } else if (index == 0) {
        return EditMenuItemTypeLeftMost;
    } else if (index == totalItems - 1) {
        return EditMenuItemTypeRightMost;
    } else {
        return EditMenuItemTypeCommon;
    }
}

- (EditMenuItem *) availableOperationForType:(EditMenuAvailableOperation) type
{
    return nil;
}

@end
