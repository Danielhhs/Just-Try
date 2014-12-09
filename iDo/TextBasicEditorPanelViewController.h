//
//  TextEditorPanelViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelViewController.h"

@class TextBasicEditorPanelViewController;

@protocol BasicTextEditorPanelViewControllerDelegate <EditorPanelViewControllerDelegate>

- (void) textAttributes:(NSDictionary *)textAttributes
didChangeFromTextEditor:(TextBasicEditorPanelViewController *)textEditor;
- (void) showColorPicker;
- (void) changeTextContainerBackgroundColor:(UIColor *) color;
@end

@interface TextBasicEditorPanelViewController : EditorPanelViewController
@property (nonatomic, weak) id<BasicTextEditorPanelViewControllerDelegate> delegate;

- (void) updateFontPickerByRange:(NSRange) range;
- (void) selectFont:(UIFont *) font;
@end
