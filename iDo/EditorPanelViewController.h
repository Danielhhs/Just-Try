//
//  EditorPanelViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerViewHelper.h"

@class EditorPanelViewController;
@protocol EditorPanelViewControllerDelegate <NSObject>

- (void) editorPanelViewController:(EditorPanelViewController *) editor
               didChangeAttributes:(NSDictionary *) attributes;
@end

@interface EditorPanelViewController : UIViewController
@property (nonatomic, strong) GenericContentDTO *attributes;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *glassianView;
@property (nonatomic, weak) id<OperationTarget> target;

@property (nonatomic, weak) id<EditorPanelViewControllerDelegate> delegate;

- (void) applyUndoRedoAttributes:(NSDictionary *)attributes;

- (void) applyAttributes:(GenericContentDTO *) attributes;

- (void) applyContentAttributes:(GenericContentDTO *) attributes;

- (void) hideTooltip;

@end
