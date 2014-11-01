//
//  ViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEditorPanelViewController.h"
#import "TextEditorPanelViewController.h"
@interface SliderEditingViewController : UIViewController<TextEditorPanelViewControllerDelegate, ImageEditorPanelViewControllerDelegate>

- (void) adjustCanvasSizeAndPosition;

@end

