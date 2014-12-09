//
//  ColorPickerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerViewControllerDelegate <NSObject>

- (void) colorPickerDidChangeToColor:(UIColor *) color;
- (void) colorPickerDidSelectColor:(UIColor *) color;

@end

@interface ColorPickerViewController : UIViewController

@property (nonatomic, weak) id<ColorPickerViewControllerDelegate> delegate;
- (void) setSelectedColor:(UIColor *) color;

@end
