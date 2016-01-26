//
//  GenericContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlPointManager.h"
#import "Operation.h"
#import "GenericContentDTO.h"

@class GenericContainerView;
@class ReflectionView;
@class CanvasView;
@protocol ContentContainerViewDelegate <NSObject>

- (void) contentViewWillBecomFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *) contentView;

- (void) contentViewDidResignFirstResponder:(GenericContainerView *) contentView;

- (void) contentView:(GenericContainerView *) contentView
 didChangeAttributes: (NSDictionary *) attributes;

- (void) contentView:(GenericContainerView *) contentView
startChangingAttribute:(NSString *)attribute;

- (void) frameDidChangeForContentView:(GenericContainerView *) contentView;

- (void) contentView:(GenericContainerView *) content willBeModifiedInCanvas:(CanvasView *) canvas;

- (void) contentViewDidPerformUndoRedoOperation:(GenericContainerView *) content;

@optional
- (void) contentViewWillResignFirstResponder:(GenericContainerView *) contentView;
@end

@interface GenericContainerView : UIView<OperationTarget, ControlPointManagerDelegate>
@property (nonatomic, strong) ReflectionView *reflection;
@property (nonatomic, strong) UIView *shadow;
@property (nonatomic, weak) id<ContentContainerViewDelegate> delegate;
@property (nonatomic, weak) CanvasView *canvas;
@property (nonatomic, strong) GenericContentDTO *attributes;

- (instancetype) initWithAttributes:(GenericContentDTO *) attributes delegate:(id<ContentContainerViewDelegate>)delegate;

- (CGSize) minSize;

- (BOOL) isContentFirstResponder;

- (CGRect) contentViewFrameFromBounds:(CGRect) bounds;

- (void) contentHasBeenAddedToSuperView;

- (UIImage *) contentSnapshot;

- (void) applyAttributes:(GenericContentDTO *) attributes;

- (void) applyChanges:(NSDictionary *)changes;

- (void) updateReflectionView;

- (void) pushUnsavedOperation;

- (UIView *) contentView;

- (void) changeBackgroundColor:(UIColor *)color;

- (void) handleLongPress;
@end
