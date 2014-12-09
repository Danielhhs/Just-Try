//
//  ColorPickerContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ColorPickerContainerViewController.h"
#import "ColorPickerViewController.h"
@interface ColorPickerContainerViewController()<ColorPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (nonatomic, strong) ColorPickerViewController *colorPicker;
@end
#define COLOR_PICKER_VIEW_WIDTH 300
#define COLOR_PICKER_VIEW_HEIGHT 400
#define COLOR_PICKER_VIEW_TOP_SPACE 50
@implementation ColorPickerContainerViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.colorPicker == nil) {
        self.colorPicker = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"ColorPickerViewController"];
        self.colorPicker.delegate = self;
        [self addChildViewController:self.colorPicker];
        self.colorPicker.view.frame = CGRectMake(0, COLOR_PICKER_VIEW_TOP_SPACE, COLOR_PICKER_VIEW_WIDTH, COLOR_PICKER_VIEW_HEIGHT);
        [self.view addSubview:self.colorPicker.view];
        [self.colorPicker didMoveToParentViewController:self];
    }
}

#pragma mark - ColorPickerViewControllerDelegate
- (void) colorPickerDidChangeToColor:(UIColor *)color
{
    [self.delegate colorPickerDidChangeToColor:color];
}

- (void) colorPickerDidSelectColor:(UIColor *)color
{
    [self.delegate colorPickerDidSelectColor:color];
}

- (void) setSelectedColor:(UIColor *)color
{
    [self.colorPicker setSelectedColor:color];
}

@end
