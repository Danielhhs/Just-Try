//
//  SlidesContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/10/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesContainerViewController.h"
#import "SlideThumbnailsManager.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "DefaultValueGenerator.h"
#import "EditorPanelManager.h"
#import "KeyConstants.h"
#import "DrawingConstants.h"
#import "CoreDataManager.h"
#import "UIView+Snapshot.h"
#import "CanvasAdjustmentHelper.h"

#define GAP_BETWEEN_VIEWS 20.f

@interface SlidesContainerViewController ()<UndoManagerDelegate, SlidesEditingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic) CGFloat keyboardOriginY;
@end

@implementation SlidesContainerViewController

#pragma mark - Memory Management
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UndoManager sharedManager] setDelegate:self];
    [self setupEditorViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setupEditorViewController
{
    self.editorViewController = [[UIStoryboard storyboardWithName:@"UtilViewControllers" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SlidesEditingViewController"];
    self.editorViewController.delegate = self;
    [self addChildViewController:self.editorViewController];
    self.editorViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.editorViewController.view];
    [self.editorViewController didMoveToParentViewController:self];
    [self adjustCanvasSizeAndPosition];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setProposalAttributes:(NSDictionary *)proposalAttributes
{
    _proposalAttributes = proposalAttributes;
    [[SlideThumbnailsManager sharedManager] setupThumbnailsWithProposalAttributes:proposalAttributes];
    self.editorViewController.slideAttributes = [self.proposalAttributes[[KeyConstants slideContentsKey]] lastObject];
}

#pragma mark - Add Content Views

- (IBAction)addImage:(id)sender {
    ImageContainerView *defaultImage = [[ImageContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultImageAttributes]];
    defaultImage.delegate = self.editorViewController;
    [defaultImage becomeFirstResponder];
    [self.editorViewController addContentViewToCanvas:defaultImage];
}

- (IBAction)addText:(id)sender {
    TextContainerView *defaultText = [[TextContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultTextAttributes]];
    defaultText.delegate = self.editorViewController;
    [defaultText startEditing];
    [defaultText becomeFirstResponder];
    [self.editorViewController addContentViewToCanvas:defaultText];
}

#pragma mark - Handle Keyboard Event
- (void) handleKeyboardShowNotification:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardOriginY = keyboardFrame.origin.y;
    CGFloat contentBottom = CGRectGetMaxY(self.editorViewController.currentSelectedContent.frame);
    [self adjustCanvasPositionForContentBottom:contentBottom];
}

- (void) handleKeyboardHideNotification:(NSNotification *) notification
{
    [CanvasAdjustmentHelper adjustCanvasSizeAndPosition:self.editorViewController.view];
    [((TextContainerView *)self.editorViewController.currentSelectedContent) finishEditing];
}

- (void) adjustCanvasSizeAndPosition
{
    [CanvasAdjustmentHelper adjustCanvasSizeAndPosition:self.editorViewController.view];
}

#pragma mark - Undo & Redo
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.editorViewController.currentSelectedContent pushUnsavedOperation];
    [[UndoManager sharedManager] undo];
}

- (IBAction)redo:(UIBarButtonItem *)sender {
    [[UndoManager sharedManager] redo];
}

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

#pragma mark - Tool Bar Actions

- (IBAction)trash:(id)sender {
    if (self.editorViewController.currentSelectedContent) {
        SimpleOperation *deleteOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants deleteKey] fromValue:self.editorViewController.currentSelectedContent];
        deleteOperation.toValue = self.editorViewController.view;
        [[UndoManager sharedManager] pushOperation:deleteOperation];
        [self.editorViewController removeCurrentContentViewFromCanvas];
    }
}

- (IBAction)saveProposal:(id)sender {
    [self.proposalAttributes setValue:[self.editorViewController.view snapshot] forKey:[KeyConstants proposalThumbnailKey]];
    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:self.proposalAttributes];
}

- (IBAction)backToProposals:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SliderThumbnailViewController
- (IBAction)showSlideThumbnails:(id)sender {
    [self.editorViewController resignPreviousFirstResponderExceptForContainer:nil];
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
    [[SlideThumbnailsManager sharedManager] showThumbnailsInViewController:self];
}

#pragma mark - SlidesEditingViewController
- (void) contentDidChangeFromEditingController:(SlidesEditingViewController *)editingController
{
    [self enableUndo];
    [self disableRedo];
}

- (void) adjustCanvasPositionForContentBottom:(CGFloat) contentBottom
{
    CGPoint bottomPoint = [self.view convertPoint:CGPointMake(0, contentBottom) fromView:self.editorViewController.view];
    CGFloat offsetForKeyboard = (self.keyboardOriginY -bottomPoint.y - GAP_BETWEEN_VIEWS) / self.editorViewController.view.transform.a;
    self.editorViewController.view.transform = CGAffineTransformTranslate(self.editorViewController.view.transform, 0, offsetForKeyboard);
}

- (void) contentViewDidBecomeFirstResponder:(GenericContainerView *)content
{
    [[SlideThumbnailsManager sharedManager] hideThumnailsFromViewController:self];
    [[EditorPanelManager sharedManager] showEditorPanelInViewController:self forContentView:content];
}

- (void) allContentViewDidResignFirstResponder
{
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
}

@end
