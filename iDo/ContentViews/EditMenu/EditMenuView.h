//
//  EditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditMenuItem.h"
#import "TextConstants.h"
#import "DrawingConstants.h"
#import "AnimationConstants.h"
#define SEPARATOR_WIDTH 1
#define EDIT_ITEM_HEIGTH 35
typedef NS_ENUM(NSInteger, EditMenuAvailableOperation) {
    EditMenuAvailableOperationCopy = 0,
    EditMenuAvailableOperationCut = 1,
    EditMenuAvailableOperationPaste = 2,
    EditMenuAvailableOperationDelete = 3,
    EditMenuAvailableOperationAnimate = 4,
    EditMenuAvailableOperationReplace = 5,
    EditMenuAvailableOperationTransition = 6,
    EditMenuAvailableOperationAnimateIn = 7,
    EditMenuAvailableOperationAnimateOut = 8,
    EditMenuAvailableOperationTransitionIn = 9
};
@class EditMenuView;
@class GenericContainerView;
@class CanvasView;
@protocol EditMenuViewDelegate <NSObject>
- (void) editMenu:(EditMenuView *) editMenu didDeleteContent:(GenericContainerView *)content;
- (void) editMenu:(EditMenuView *) editMenu didCutContent:(GenericContainerView *)content;
- (void) editMenu:(EditMenuView *) editMenu didPasteContent:(GenericContainerView *)content;
- (void) editMenu:(EditMenuView *) editMenu willShowAnimationEditorForContent:(UIView *)view forType:(AnimationEvent) animationEvent;
- (CGPoint) thumbnailLocationForCurrentSlide;
- (void) refreshEditMenuToView:(GenericContainerView *)content;
@end

@interface EditMenuView : UIView
@property (nonatomic, strong) NSMutableArray *availableOperations;
@property (nonatomic, strong) NSMutableArray *separatorLocations;
@property (nonatomic, weak) UIView *trigger;
@property (nonatomic, weak) EditMenuItem *currentSelectedItem;
@property (nonatomic) CGFloat itemHeight;
@property (nonatomic, weak) id<EditMenuViewDelegate> delegate;
- (void) hide;
- (void) update;
- (void) layoutButtons;
- (CGRect) frameFromCurrentButtons;
- (EditMenuItem *) availableOperationForType:(EditMenuAvailableOperation) type;
- (EditMenuItemType) itemTypeForButtonItem:(EditMenuItem *) item index:(NSInteger) index totalItems:(NSInteger) totalItems;
@end
