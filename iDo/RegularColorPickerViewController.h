//
//  RegularColorPickerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegularColorPickerViewController;
@protocol RegularColorPickerViewControllerDelegate <NSObject>

- (void) regularColorPickerViewController:(RegularColorPickerViewController *) controller didSelectColor:(UIColor *) color;

@end

@interface RegularColorPickerViewController : UIViewController
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, weak) id<RegularColorPickerViewControllerDelegate> delegate;
@end
