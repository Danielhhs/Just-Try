//
//  ViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesEditingViewController.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "EditorPanelManager.h"
#import "TooltipView.h"
#import "CanvasView.h"
#import "CustomTapTextView.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "KeyConstants.h"
#import "UIView+Snapshot.h"
#import "CoreDataManager.h"
#import "DefaultValueGenerator.h"
#import "SlideThumbnailsManager.h"

#define GAP_BETWEEN_VIEWS 20.f

@interface SlidesEditingViewController ()<ImageContainerViewDelegate, TextContainerViewDelegate, CanvasViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UndoManagerDelegate, OperationTarget>
@property (nonatomic, strong) GenericContainerView *currentSelectedContent;
@property (weak, nonatomic) IBOutlet CanvasView *canvas;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic) CGFloat keyboardOriginY;
@property (nonatomic) NSUInteger currentSelectionOriginalIndex;
@end

@implementation SlidesEditingViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkTextColor];
    self.canvas.delegate = self;
    [[UndoManager sharedManager] setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setProposalAttributes:(NSDictionary *)proposalAttributes
{
    _proposalAttributes = proposalAttributes;
    [[SlideThumbnailsManager sharedManager] setupThumbnailsWithProposalAttributes:proposalAttributes];
}

#pragma mark - User Interactions

- (IBAction)addImage:(id)sender {
    ImageContainerView *view = [[ImageContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultImageAttributes]];
    view.delegate = self;
    [view becomeFirstResponder];
    [self.canvas addSubview:view];
}

- (IBAction)addText:(id)sender {
    TextContainerView *view = [[TextContainerView alloc] initWithAttributes:[DefaultValueGenerator defaultTextAttributes]];
    view.delegate = self;
    [view startEditing];
    [view becomeFirstResponder];
    [self.canvas addSubview:view];
}

#pragma mark - ContentContainerViewDelegate
- (void) textViewDidSelectTextRange:(NSRange)selectedRange
{
    [[EditorPanelManager sharedManager] contentViewDidSelectRange:selectedRange];
}

- (void) contentViewDidResignFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = nil;
    [self switchView:contentView toIndex:self.currentSelectionOriginalIndex inSuperView:self.canvas];
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
}

- (void) contentViewWillBecomFirstResponder:(GenericContainerView *)contentView
{
    [self resignPreviousFirstResponderExceptForContainer:contentView];
    self.currentSelectionOriginalIndex = [[self.canvas subviews] indexOfObject:contentView];
}

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = contentView;
    [self.canvas disablePinch];
    [self switchView:contentView toIndex:[[self.canvas subviews] count] - 1 inSuperView:self.canvas];
    [[SlideThumbnailsManager sharedManager] hideThumnailsFromViewController:self];
    [[EditorPanelManager sharedManager] showEditorPanelInViewController:self forContentView:contentView];
}

- (void) contentView:(GenericContainerView *)contentView didChangeAttributes:(NSDictionary *)attributes
{
    if (attributes) {
        [[EditorPanelManager sharedManager] makeCurrentEditorApplyChanges:attributes];
    }
    [self enableUndo];
    [self disableRedo];
    [[UndoManager sharedManager] clearRedoStack];
}

- (void) frameDidChangeForContentView:(GenericContainerView *)contentView
{
    CGFloat contentBottom = CGRectGetMaxY(contentView.frame);
    [self adjustCanvasPositionForContentBottom:contentBottom];
}

- (void) resignPreviousFirstResponderExceptForContainer:(GenericContainerView *) container
{
    for (UIView *subView in self.canvas.subviews) {
        if ([subView isKindOfClass:[GenericContainerView class]] && subView != container) {
            GenericContainerView *containerView = (GenericContainerView *) subView;
            if ([containerView isContentFirstResponder]) {
                [containerView resignFirstResponder];
            }
        }
    }
}

- (void) handleTapOnImage:(ImageContainerView *)container
{
    UIPopoverController *popOver = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
    [popOver presentPopoverFromRect:container.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) textViewDidStartEditing:(TextContainerView *)textView
{
    [[EditorPanelManager sharedManager] selectTextBasicEditorPanel];
}

#pragma mark - EditorPanelContainerViewControllerDelegate
- (void) editorContainerViewController:(EditorPanelContainerViewController *)container didChangeAttributes:(NSDictionary *)attributes
{
    [self.currentSelectedContent applyAttributes:attributes];
}

#pragma mark - TextEditorPanelViewController

- (void) textAttributes:(NSDictionary *)textAttributes didChangeFromTextEditor:(TextEditorPanelContainerViewController *)textEditor
{
    [self.currentSelectedContent applyAttributes:textAttributes];
}

- (void) textEditorDidSelectNonBasicEditor:(TextEditorPanelContainerViewController *)textEditorController
{
    [((TextContainerView *)self.currentSelectedContent) finishEditing];
}

#pragma mark - ImagePicker
- (UIImagePickerController *) imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = NO;
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    return _imagePicker;
}

#pragma mark - UIImagePickerViewControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self updateCurrentImageContentWithImage:selectedImage];
}

- (void) updateCurrentImageContentWithImage:(UIImage *) image
{
    if ([self.currentSelectedContent isKindOfClass:[ImageContainerView class]]) {
        ImageContainerView *imageContainer = (ImageContainerView *) self.currentSelectedContent;
        imageContainer.image = image;
    }
}

#pragma mark - CanvasViewDelegate
- (void) userDidTapInCanvas:(CanvasView *)canvas
{
    [self resignPreviousFirstResponderExceptForContainer:nil];
    [self.canvas enablePinch];
}

#pragma mark - Handle Keyboard Event
- (void) handleKeyboardShowNotification:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardOriginY = keyboardFrame.origin.y;
    CGFloat contentBottom = CGRectGetMaxY(self.currentSelectedContent.frame);
    [self adjustCanvasPositionForContentBottom:contentBottom];
}

- (void) handleKeyboardHideNotification:(NSNotification *) notification
{
    self.canvas.transform = CGAffineTransformTranslate(self.canvas.transform, 0, -1 * self.canvas.transform.ty);
    [((TextContainerView *)self.currentSelectedContent) finishEditing];
}

- (void) adjustCanvasSizeAndPosition
{
    CGFloat offset = [EditorPanelManager currentEditorWidth] + GAP_BETWEEN_VIEWS;
    if (offset == GAP_BETWEEN_VIEWS) {
        offset = -1 * [[SlideThumbnailsManager sharedManager] thumbnailViewControllerWidth] - GAP_BETWEEN_VIEWS;
    }
    CGFloat scale = (self.canvas.bounds.size.width - abs(offset)) / self.canvas.bounds.size.width;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    transform = CGAffineTransformTranslate(transform, (-1 * offset +  GAP_BETWEEN_VIEWS) * scale, 0);
    self.canvas.transform = transform;
}

- (void) adjustCanvasPositionForContentBottom:(CGFloat) contentBottom
{
    CGPoint bottomPoint = [self.view convertPoint:CGPointMake(0, contentBottom) fromView:self.canvas];
    CGFloat offsetForKeyboard = (self.keyboardOriginY -bottomPoint.y - GAP_BETWEEN_VIEWS) / self.canvas.transform.a;
    self.canvas.transform = CGAffineTransformTranslate(self.canvas.transform, 0, offsetForKeyboard);
}

#pragma mark - Undo and Redo
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.currentSelectedContent pushUnsavedOperation];
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

- (void) performOperation:(SimpleOperation *)operation
{
    if ([operation.key isEqualToString:[KeyConstants deleteKey]]) {
        GenericContainerView *content = (GenericContainerView *)operation.fromValue;
        [content removeFromSuperview];
        [content resignFirstResponder];
    } else if ([operation.key isEqualToString:[KeyConstants addKey]]) {
        CanvasView *canvas = (CanvasView *)operation.fromValue;
        GenericContainerView *content = (GenericContainerView *) operation.toValue;
        [canvas addSubview:content];
        [content becomeFirstResponder];
    }
}

- (void) switchView:(UIView *) view toIndex:(NSUInteger) index inSuperView:(UIView *) superView
{
    if ([[superView subviews] count] > 1) {
        [superView insertSubview:view atIndex:index];
    }
}

#pragma mark - Tool Bar Actions

- (IBAction)trash:(id)sender {
    if (self.currentSelectedContent) {
        SimpleOperation *deleteOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants deleteKey] fromValue:self.currentSelectedContent];
        deleteOperation.toValue = self.canvas;
        [[UndoManager sharedManager] pushOperation:deleteOperation];
        [self.currentSelectedContent removeFromSuperview];
        [self.currentSelectedContent resignFirstResponder];
    }
}

- (IBAction)saveProposal:(id)sender {
    [self.proposalAttributes setValue:[self.canvas snapshot] forKey:[KeyConstants proposalThumbnailKey]];
    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:self.proposalAttributes];
}

- (IBAction)backToProposals:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SliderThumbnailViewController
- (IBAction)showSlideThumbnails:(id)sender {
    [self resignPreviousFirstResponderExceptForContainer:nil];
    [[SlideThumbnailsManager sharedManager] showThumbnailsInViewController:self];
}


@end
