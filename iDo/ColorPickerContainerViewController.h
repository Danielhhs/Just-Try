//
//  ColorPickerContainerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerContainerViewControllerDelegate <NSObject>

- (void) colorPickerDidChangeToColor:(UIColor *) color;
- (void) colorPickerDidSelectColor:(UIColor *) color;

@end

@interface ColorPickerContainerViewController : UIViewController
@property (nonatomic, weak) id<ColorPickerContainerViewControllerDelegate> delegate;
@end
