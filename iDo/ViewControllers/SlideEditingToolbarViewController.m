//
//  SlideEditingToolbarViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/21/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlideEditingToolbarViewController.h"
#import "UndoManager.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "DefaultValueGenerator.h"

@interface SlideEditingToolbarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@end

@implementation SlideEditingToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UndoManager sharedManager] setDelegate:self];
    [self disableRedo];
    [self disableUndo];
    [self.undoButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.undoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.redoButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.redoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    // Do any additional setup after loading the view.
}

#pragma mark - Undo & Redo

- (void) enableRedo
{
    self.redoButton.enabled = YES;
}

- (void) enableUndo
{
    self.undoButton.enabled = YES;
}

- (void) disableUndo
{
    self.undoButton.enabled = NO;
}

- (void) disableRedo
{
    self.redoButton.enabled = NO;
}

- (IBAction)undo:(id)sender {
    [self.delegate toolBarViewControllerWillPerformUndoAction:self];
    [[UndoManager sharedManager] undo];
}

- (IBAction)redo:(id)sender {
    [[UndoManager sharedManager] redo];
}

#pragma mark - Add Contents

- (IBAction)addImage:(id)sender {
    ImageContainerView *defaultImage = [[ImageContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultImageAttributes] delegate:nil];
    [self.delegate addGenericContentView:defaultImage];
}

- (IBAction)addText:(id)sender {
    TextContainerView *defaultText = [[TextContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultTextAttributes] delegate:nil];
    [self.delegate addGenericContentView:defaultText];
}

#pragma mark - Other Actions

- (IBAction)trash:(id)sender {
    [self.delegate deleteCurrentSelectedContent];
}

- (IBAction)saveProposal:(id)sender {
    [self.delegate saveProposal];
}

- (IBAction)backToProposals:(id)sender {
    [self.delegate backToProposals];
}

- (IBAction)showSlideThumbnails:(id)sender {
}
- (IBAction)editCurrentContent:(id)sender {
    [self.delegate editCurrentContent];
}

@end
