//
//  SlidesContainerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 11/10/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesContainerViewController.h"
#import "SlideThumbnailsManager.h"
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
#import "SlideEditingToolbarViewController.h"

#define GAP_BETWEEN_VIEWS 20.f

@interface SlidesContainerViewController ()<SlidesEditingViewControllerDelegate, SlidesThumbnailViewControllerDelegate, ContentEditMenuViewDelegate, SlideEditingToolbarDelegate>
@property (nonatomic) NSInteger currentSelectSlideIndex;
@property (nonatomic) CGFloat keyboardOriginY;
@property (nonatomic, strong) NSMutableArray *slideViews;
@property (nonatomic, strong) NSMutableArray *slideAttributes;
@property (nonatomic, strong) ContentEditMenuView *editMenu;
@property (nonatomic, strong) SlideEditingToolbarViewController *toolbar;
@end

@implementation SlidesContainerViewController

#pragma mark - Memory Management
- (void) awakeFromNib
{
    [self setupToolbarViewController];
    [self setupEditorViewController];
    [self.view bringSubviewToFront:self.toolbar.view];
    self.editMenu = [[ContentEditMenuView alloc] initWithFrame:CGRectZero];
    self.editMenu.delegate = self;
    [self.editorViewController.view addSubview:self.editMenu];
    self.editorViewController.editMenu = self.editMenu;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[UndoManager sharedManager] clearUndoStack];
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

- (void) setupToolbarViewController
{
    self.toolbar = [[UIStoryboard storyboardWithName:@"UtilViewControllers" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SlideEditingToolbarViewController"];
    self.toolbar.delegate = self;
    [self addChildViewController:self.toolbar];
    self.toolbar.view.frame = CGRectMake(0, 0, 1024, 44);
    [self.view addSubview:self.toolbar.view];
    [self.toolbar didMoveToParentViewController:self];
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

#pragma mark - SlidesEditingViewControllerDelegate
- (void) contentDidChangeFromEditingController:(SlidesEditingViewController *)editingController
{
    [self.toolbar enableUndo];
    [self.toolbar disableRedo];
    [[SlideThumbnailsManager sharedManager] updateSlideSnapshotForItemAtIndex:self.currentSelectSlideIndex];
}

- (void) adjustCanvasPositionForContentBottom:(CGFloat) contentBottom
{
    CGPoint bottomPoint = [self.view convertPoint:CGPointMake(0, contentBottom) fromView:self.editorViewController.view];
    if (self.keyboardOriginY) {
        CGFloat offsetForKeyboard = (self.keyboardOriginY -bottomPoint.y - GAP_BETWEEN_VIEWS) / self.editorViewController.view.transform.a;
        self.editorViewController.view.transform = CGAffineTransformTranslate(self.editorViewController.view.transform, 0, offsetForKeyboard);
    }
}

- (void) contentView:(GenericContainerView *)content didRemoveFromView:(UIView *)canvas
{
    [self.editMenu hide];
}

- (void) contentViewDidPerformUndoRedoOperation:(GenericContainerView *)content
{
    self.editMenu.triggeredContent = content;
    [self.editMenu update];
    [[SlideThumbnailsManager sharedManager] updateSlideSnapshotForItemAtIndex:self.currentSelectSlideIndex];
}

- (void) contentView:(GenericContainerView *)content willBeModifiedInCanvas:(CanvasView *)canvas
{
    if ([canvas isKindOfClass:[CanvasView class]]) {
        NSInteger index = [self.slideViews indexOfObject:canvas];
        self.currentSelectSlideIndex = index;
    }
}

- (void) contentViewDidBecomeFirstResponder:(GenericContainerView *)content
{
    [[EditorPanelManager sharedManager] switchCurrentEditoToEditorForView:content inViewController:self];
}

- (void) allContentViewDidResignFirstResponder
{
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
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

#pragma mark - SlideEditingToolbarDelegate
- (void) toolBarViewControllerWillPerformUndoAction:(SlideEditingToolbarViewController *)controller
{
    [self.editorViewController.currentSelectedContent pushUnsavedOperation];
}

- (void) backToProposals
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveProposal
{
    [self.editorViewController saveSlideAttributes];
    [self.proposalAttributes setValue:[self.editorViewController.view snapshot] forKey:[KeyConstants proposalThumbnailKey]];
    [self.proposalAttributes setValue:@(self.currentSelectSlideIndex) forKey:[KeyConstants proposalCurrentSelectedSlideKey]];
    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:self.proposalAttributes];
}

- (void) addGenericContentView:(GenericContainerView *) content
{
    [self.editorViewController addContentViewToCanvas:content];
    [content becomeFirstResponder];
    SimpleOperation *addOperation = [[SimpleOperation alloc] initWithTargets:@[content] key:[KeyConstants addKey] fromValue:nil];
    addOperation.toValue = self.editorViewController.canvas;
    [[UndoManager sharedManager] pushOperation:addOperation];
    [[SlideThumbnailsManager sharedManager] updateSlideSnapshotForItemAtIndex:self.currentSelectSlideIndex];
}

- (void) deleteCurrentSelectedContent
{
    if (self.editorViewController.currentSelectedContent) {
        SimpleOperation *deleteOperation = [[SimpleOperation alloc] initWithTargets:@[self.editorViewController.currentSelectedContent] key:[KeyConstants deleteKey] fromValue:self.editorViewController.canvas];
        [[UndoManager sharedManager] pushOperation:deleteOperation];
        [self.editorViewController removeCurrentContentViewFromCanvas];
    }
}

- (void) showSlideThumbnails
{
    [self.editorViewController saveSlideAttributes];
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
    [[SlideThumbnailsManager sharedManager] selectSlideAtIndex:self.currentSelectSlideIndex];
    [[SlideThumbnailsManager sharedManager] showThumbnailsInViewController:self];
}
@end
