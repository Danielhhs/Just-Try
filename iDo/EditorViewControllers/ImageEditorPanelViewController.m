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
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;
@end

@implementation ImageEditorPanelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restore {
    
    [super restore];
}
- (IBAction)buttonTest:(UIButton *)sender {
    sender.selected = !sender.selected;
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
