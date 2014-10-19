//
//  ViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ViewController.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "EditorPanelManager.h"

@interface ViewController ()<ContentContainerViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    ImageContainerView *view = [[ImageContainerView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"background.jpg"].CGImage;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView)]];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - User Interactions

- (void) tapOnView
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(resignFirstResponder)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addImage:(id)sender {
    ImageContainerView *view = [[ImageContainerView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    view.delegate = self;
    [view becomeFirstResponder];
    [self.view addSubview:view];
}

- (IBAction)addText:(id)sender {
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"Test Test" attributes:@{}];
    TextContainerView *view = [[TextContainerView alloc] initWithAttributedString:attrStr];
    [view becomeFirstResponder];
    [self.view addSubview:view];
}

- (IBAction)showPanel:(id)sender {
    [[EditorPanelManager sharedManager] showImageEditorInViewController:self imageInformation:nil];
}

#pragma mark - ContentContainerViewDelegate
- (void) contentViewDidResignFirstResponder:(GenericContainerView *)contentView
{
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
}

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *)contentView
{
    [[EditorPanelManager sharedManager] showEditorPanelInViewController:self forContentView:contentView];
}
@end
