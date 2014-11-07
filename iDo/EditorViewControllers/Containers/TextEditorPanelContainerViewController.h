//
//  TextEditorPanelContainerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelContainerViewController.h"

@class TextEditorPanelContainerViewController;

@protocol TextEditorPanelContainerViewControllerDelegate <EditorPanelContainerViewControllerDelegate>

- (void) textAttributes:(NSDictionary *)textAttributes didChangeFromTextEditor:(TextEditorPanelContainerViewController *)textEditorContainer;

- (void) textEditorDidSelectNonBasicEditor:(TextEditorPanelContainerViewController *) textEditorController;
@end

@interface TextEditorPanelContainerViewController : EditorPanelContainerViewController

@property (nonatomic, weak) id<TextEditorPanelContainerViewControllerDelegate> delegate;

- (void) updateFontPickerByRange:(NSRange) range;
- (void) selectBasicEditor;
@end
