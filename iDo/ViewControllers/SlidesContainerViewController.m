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
#import "ProposalAttributesManager.h"
#import "ContentEditMenuView.h"

#define GAP_BETWEEN_VIEWS 20.f

@interface SlidesContainerViewController ()<UndoManagerDelegate, SlidesEditingViewControllerDelegate, SlidesThumbnailViewControllerDelegate, ContentEditMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic) NSInteger currentSelectSlideIndex;
@property (nonatomic) CGFloat keyboardOriginY;
@property (nonatomic, strong) NSMutableArray *slideViews;
@property (nonatomic, strong) NSMutableArray *slideAttributes;
@property (nonatomic, strong) ContentEditMenuView *editMenu;
@end

@implementation SlidesContainerViewController

#pragma mark - Memory Management
- (void) awakeFromNib
{
    [[UndoManager sharedManager] setDelegate:self];
    [self setupEditorViewController];
    self.editMenu = [[ContentEditMenuView alloc] initWithFrame:CGRectZero];
    self.editMenu.delegate = self;
    [self.editorViewController.view addSubview:self.editMenu];
    self.editorViewController.editMenu = self.editMenu;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) loadAllSlideViews
{
    self.slideViews = [NSMutableArray array];
    NSArray *slides = self.proposalAttributes[[KeyConstants proposalSlidesKey]];
    for (NSDictionary *slide in slides) {
        CanvasView *slideContent = [[CanvasView alloc] initWithAttributes:slide delegate:self.editorViewController contentDelegate:self.editorViewController];
        [self.slideViews addObject:slideContent];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self saveProposal];
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
    [[SlideThumbnailsManager sharedManager] hideThumnailsFromViewController:self];
    [super viewWillDisappear:animated];
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

- (void) setProposalAttributes:(NSMutableDictionary *)proposalAttributes
{
    _proposalAttributes = proposalAttributes;
    [self loadAllSlideViews];
    [[SlideThumbnailsManager sharedManager] setupThumbnailsWithProposalAttributes:proposalAttributes];
    [[SlideThumbnailsManager sharedManager] setSlideThumbnailControllerDelegate:self];
    self.slideAttributes = self.proposalAttributes[[KeyConstants proposalSlidesKey]];
    self.currentSelectSlideIndex = [self.proposalAttributes[[KeyConstants proposalCurrentSelectedSlideKey]] integerValue];
}

- (void) setCurrentSelectSlideIndex:(NSInteger)currentSelectSlideIndex
{
    _currentSelectSlideIndex = currentSelectSlideIndex;
    [[SlideThumbnailsManager sharedManager] selectSlideAtIndex:self.currentSelectSlideIndex];
    self.editorViewController.slideAttributes = [self.slideAttributes objectAtIndex:self.currentSelectSlideIndex];
    self.editorViewController.canvas = [self.slideViews objectAtIndex:self.currentSelectSlideIndex];
}

#pragma mark - Add Content Views

- (IBAction)addImage:(id)sender {
    ImageContainerView *defaultImage = [[ImageContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultImageAttributes] delegate:self.editorViewController];
    [self addGenericContentView:defaultImage];
}

- (IBAction)addText:(id)sender {
    TextContainerView *defaultText = [[TextContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultTextAttributes] delegate:self.editorViewController];
    [defaultText startEditing];
    [self addGenericContentView:defaultText];
}

- (void) addGenericContentView:(GenericContainerView *) content
{
    [content becomeFirstResponder];
    [self.editorViewController addContentViewToCanvas:content];
    SimpleOperation *addOperation = [[SimpleOperation alloc] initWithTargets:@[content] key:[KeyConstants addKey] fromValue:nil];
    addOperation.toValue = self.editorViewController.canvas;
    [[UndoManager sharedManager] pushOperation:addOperation];
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
    self.keyboardOriginY = 0;
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
    [self deleteCurrentSelectedContent];
}

- (void) deleteCurrentSelectedContent
{
    if (self.editorViewController.currentSelectedContent) {
        SimpleOperation *deleteOperation = [[SimpleOperation alloc] initWithTargets:@[self.editorViewController.currentSelectedContent] key:[KeyConstants deleteKey] fromValue:self.editorViewController.currentSelectedContent];
        deleteOperation.toValue = self.editorViewController.canvas;
        [[UndoManager sharedManager] pushOperation:deleteOperation];
        [self.editorViewController removeCurrentContentViewFromCanvas];
    }
}

- (IBAction)saveProposal:(id)sender {
    [self saveProposal];
}

- (void) saveProposal
{
    [self.editorViewController saveSlideAttributes];
    [self.proposalAttributes setValue:[self.editorViewController.view snapshot] forKey:[KeyConstants proposalThumbnailKey]];
    [self.proposalAttributes setValue:@(self.currentSelectSlideIndex) forKey:[KeyConstants proposalCurrentSelectedSlideKey]];
    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:self.proposalAttributes];
}

- (IBAction)backToProposals:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SlidesEditingViewControllerDelegate
- (void) contentDidChangeFromEditingController:(SlidesEditingViewController *)editingController
{
    [self enableUndo];
    [self disableRedo];
    [[SlideThumbnailsManager sharedManager] updateSlideSnapshotIfNeccessary];
}

- (void) adjustCanvasPositionForContentBottom:(CGFloat) contentBottom
{
    CGPoint bottomPoint = [self.view convertPoint:CGPointMake(0, contentBottom) fromView:self.editorViewController.view];
    if (self.keyboardOriginY) {
        CGFloat offsetForKeyboard = (self.keyboardOriginY -bottomPoint.y - GAP_BETWEEN_VIEWS) / self.editorViewController.view.transform.a;
        self.editorViewController.view.transform = CGAffineTransformTranslate(self.editorViewController.view.transform, 0, offsetForKeyboard);
    }
}

- (void) contentViewDidBecomeFirstResponder:(GenericContainerView *)content
{
}

- (void) allContentViewDidResignFirstResponder
{
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
    [[SlideThumbnailsManager sharedManager] showThumbnailsInViewController:self];
}

#pragma mark - SliderThumbnailViewController
- (IBAction)showSlideThumbnails:(id)sender {
    [self.editorViewController saveSlideAttributes];
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
    [[SlideThumbnailsManager sharedManager] selectSlideAtIndex:self.currentSelectSlideIndex];
    [[SlideThumbnailsManager sharedManager] showThumbnailsInViewController:self];
}

#pragma mark - SlidesThumbnailViewControllerDelegate
- (void) slideDidAddAtIndex:(NSInteger)index fromSlidesThumbnailViewController:(SlidesThumbnailViewController *)thumbnailController
{
    [[ProposalAttributesManager sharedManager] addNewSlideToProposal:self.proposalAttributes atIndex:index];
    [self.slideViews insertObject:[[CanvasView alloc] initWithAttributes:[DefaultValueGenerator defaultSlideAttributes] delegate:self.editorViewController contentDelegate:self.editorViewController] atIndex:index];
    [[SlideThumbnailsManager sharedManager] setupThumbnailsWithProposalAttributes:self.proposalAttributes];
    self.currentSelectSlideIndex = index;
}

- (void) slideThumbnailController:(SlidesThumbnailViewController *)thumbnailController didSelectSlideAtIndex:(NSInteger)index
{
    [self.editorViewController saveSlideAttributes];
    self.currentSelectSlideIndex = index;
}

- (void) slideThumbnailController:(SlidesThumbnailViewController *)controller didSwtichCellAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    CanvasView *selectedSlide = self.slideViews[fromIndex];
    [self.slideViews removeObject:selectedSlide];
    [self.slideViews insertObject:selectedSlide atIndex:toIndex];
    NSMutableDictionary *selectedSlideAttributes = self.slideAttributes[fromIndex];
    [self.slideAttributes removeObject:selectedSlideAttributes];
    [self.slideAttributes insertObject:selectedSlideAttributes atIndex:toIndex];
    self.currentSelectSlideIndex = toIndex;
    [[SlideThumbnailsManager sharedManager] setupThumbnailsWithProposalAttributes:self.proposalAttributes];
}

#pragma mark - ContentEditMenuDelegate
- (void) editMenu:(ContentEditMenuView *)editMenu didDeleteContent:(GenericContainerView *)content
{
    [self deleteCurrentSelectedContent];
}

- (void) editMenu:(ContentEditMenuView *)editMenu didEditContent:(GenericContainerView *)content
{
    [[SlideThumbnailsManager sharedManager] hideThumnailsFromViewController:self];
    [[EditorPanelManager sharedManager] showEditorPanelInViewController:self forContentView:content];
}

- (void) editMenu:(ContentEditMenuView *)editMenu didCutContent:(GenericContainerView *)content
{
    [self deleteCurrentSelectedContent];
}

- (void) editMenu:(ContentEditMenuView *)editMenu didPasteContent:(GenericContainerView *)content
{
    [self addGenericContentView:content];
}

@end
