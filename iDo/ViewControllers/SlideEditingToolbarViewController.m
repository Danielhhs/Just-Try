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

@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@end

@implementation SlideEditingToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UndoManager sharedManager] setDelegate:self];
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

- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.delegate toolBarViewControllerWillPerformUndoAction:self];
    [[UndoManager sharedManager] undo];
}

- (IBAction)redo:(UIBarButtonItem *)sender {
    [[UndoManager sharedManager] redo];
}

#pragma mark - Add Contents

- (IBAction)addImage:(id)sender {
    ImageContainerView *defaultImage = [[ImageContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultImageAttributes] delegate:nil];
    [self.delegate addGenericContentView:defaultImage];
}

- (IBAction)addText:(id)sender {
    TextContainerView *defaultText = [[TextContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultTextAttributes] delegate:nil];
    [defaultText startEditing];
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
    [self.delegate showSlideThumbnails];
}

@end
