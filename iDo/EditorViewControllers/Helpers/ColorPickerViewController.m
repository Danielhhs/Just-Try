//
//  ColorPickerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"
#import "RSOpacitySlider.h"

@interface ColorPickerViewController ()<RSColorPickerViewDelegate>
@property (weak, nonatomic) IBOutlet RSColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet RSOpacitySlider *opacitySlider;
@property (weak, nonatomic) IBOutlet RSBrightnessSlider *brightnessSlider;

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorPickerView.delegate = self;
    self.colorPickerView.cropToCircle = YES;
    self.colorPickerView.showLoupe = YES;
    self.colorPickerView.clipsToBounds = NO;
    self.opacitySlider.colorPicker = self.colorPickerView;
    self.brightnessSlider.colorPicker = self.colorPickerView;
}

#pragma mark - RSColorPickerViewDelegate
- (void) colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker
{
    [self.delegate colorPickerDidChangeToColor:colorPicker.selectionColor];
}

- (void) colorPicker:(RSColorPickerView *)colorPicker touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate colorPickerDidSelectColor:colorPicker.selectionColor];
}

- (void) setSelectedColor:(UIColor *)color
{
    self.colorPickerView.selectionColor = color;
    CGFloat hue, saturation, brightness, alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    self.colorPickerView.opacity = alpha;
    self.colorPickerView.brightness = brightness;
    self.opacitySlider.value = alpha;
    self.brightnessSlider.value = brightness;
}
@end
