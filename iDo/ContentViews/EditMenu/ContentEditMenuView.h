//
//  ContentEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 11/16/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationConstants.h"
@class GenericContainerView;
@class ContentEditMenuView;
@class CanvasView;
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

@protocol ContentEditMenuViewDelegate <NSObject>

- (void) editMenu:(ContentEditMenuView *) editMenu didDeleteContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu didCutContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu didPasteContent:(GenericContainerView *)content;
- (void) editMenu:(ContentEditMenuView *) editMenu willShowAnimationEditorForContent:(UIView *)view forType:(AnimationType) animationType;

@end

@interface ContentEditMenuView : UIView

@property (nonatomic, weak) GenericContainerView *triggeredContent;
@property (nonatomic, weak) CanvasView *triggeredCanvas;
@property (nonatomic, weak) id<ContentEditMenuViewDelegate> delegate;
- (void) showWithAvailableOperations:(NSArray *) availableOperations toContent:(GenericContainerView *) content;
- (void) showWithAvailableOperations:(NSArray *) availableOperations toCanvas:(CanvasView *) canvas;
- (void) hide;
- (void) update;
- (void) updateEditAnimationItemWithAnimationName:(NSString *) animationName;
@end
