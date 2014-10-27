//
//  TextEditorPanelViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelViewController.h"

@class TextEditorPanelViewController;

@protocol TextEditorPanelViewControllerDelegate <EditorPanelViewControllerDelegate>

- (void) textAttributes:(NSDictionary *)textAttributes
didChangeFromTextEditor:(TextEditorPanelViewController *)textEditor;

@end

@interface TextEditorPanelViewController : EditorPanelViewController

@property (nonatomic, weak) id<TextEditorPanelViewControllerDelegate> delegate;

@end
