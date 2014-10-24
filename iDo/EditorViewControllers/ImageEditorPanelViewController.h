//
//  ImageEditorPanelViewController.h
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorPanelViewController.h"

@protocol ImageEditorPanelViewControllerDelegate <EditorPanelViewControllerDelegate>

@end

@interface ImageEditorPanelViewController : EditorPanelViewController<UINavigationBarDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) id<ImageEditorPanelViewControllerDelegate> delegate;

@end
