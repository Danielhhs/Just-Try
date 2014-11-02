//
//  EditorPanelContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/1/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditorPanelContainerViewController.h"

@interface EditorPanelContainerViewController ()

@end

@implementation EditorPanelContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) applyAttributes:(NSDictionary *)attributes
{
    
}

- (void) hideTooltip
{
    
}

- (void) editorPanelViewController:(EditorPanelViewController *)editor didChangeAttributes:(NSDictionary *)attributes
{
    [self.delegate editorContainerViewController:self didChangeAttributes:attributes];
}


- (CGRect) contentFrameFromYPosition:(CGFloat) yPosition
{
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = yPosition;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - yPosition;
    return frame;
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
