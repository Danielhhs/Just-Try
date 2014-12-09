//
//  ColorSelectionManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColorPickerContainerViewController.h"

typedef NS_ENUM(NSInteger, ColorUsageType) {
    ColorUsageTypeTextColor = 0,
    ColorUsageTypeTextBackground = 1,
    ColorUsageTypeGradient = 2
};

@interface ColorSelectionManager : NSObject

+ (ColorSelectionManager *) sharedManager;

- (void) showColorPickerFromRect:(CGRect)rect inView:(UIView *) view forType:(ColorUsageType)type selectedColor:(UIColor *)color;

- (void) hideColorPicker;

- (UIColor *) selectedColorForType:(ColorUsageType) usage;

- (void) setColorPickerDelegate:(id<ColorPickerContainerViewControllerDelegate>)delegate;

@end
