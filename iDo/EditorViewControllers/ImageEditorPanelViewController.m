//
//  ImageEditorPanelViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/17/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageEditorPanelViewController.h"
#import "ImageHelper.h"
#import "EditorPanelManager.h"

@interface ImageEditorPanelViewController ()

@end

@implementation ImageEditorPanelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *blurredImage = [ImageHelper blurredImageWithSourceImage:self.backgroundImage inRect:self.view.bounds];
    self.view.layer.contents = (__bridge id)blurredImage.CGImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTap:(id)sender {
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
