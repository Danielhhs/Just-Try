//
//  ViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorPanelContainerViewController.h"
#import "TextEditorPanelContainerViewController.h"

@interface SliderEditingViewController : UIViewController<TextEditorPanelContainerViewControllerDelegate, EditorPanelContainerViewControllerDelegate>

- (void) adjustCanvasSizeAndPosition;

@end

