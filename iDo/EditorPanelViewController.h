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

- (void) restoreFromEditorPanelViewController:(EditorPanelViewController *) editor;

@end

@interface EditorPanelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIVisualEffectView *glassianView;

@property (nonatomic, weak) id<EditorPanelViewControllerDelegate> delegate;

- (void) applyAttributes:(NSDictionary *) attributes;
- (void) restore;

- (void) hideTooltip;

@end
