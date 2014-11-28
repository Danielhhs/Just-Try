//
//  ColorPickerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "RSColorPickerView.h"

@interface ColorPickerViewController ()<RSColorPickerViewDelegate>
@property (weak, nonatomic) IBOutlet RSColorPickerView *colorPickerView;

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorPickerView.delegate = self;
    self.colorPickerView.cropToCircle = YES;
    self.colorPickerView.showLoupe = YES;
    self.colorPickerView.clipsToBounds = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
