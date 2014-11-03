//
//  ViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SliderEditingViewController.h"
#import "ImageContainerView.h"
#import "TextContainerView.h"
#import "EditorPanelManager.h"
#import "TooltipView.h"
#import "CanvasView.h"
#import "CustomTapTextView.h"
#import "UndoManager.h"

#define GAP_BETWEEN_VIEWS 20.f

@interface SliderEditingViewController ()<ImageContainerViewDelegate, CanvasViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UndoManagerDelegate>
@property (nonatomic, strong) GenericContainerView *currentSelectedContent;
@property (weak, nonatomic) IBOutlet CanvasView *canvas;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic) CGFloat offsetForKeyboard;
@property (nonatomic) CGFloat keyboardOriginY;
@end

@implementation SliderEditingViewController

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

#pragma mark - User Interactions

- (IBAction)addImage:(id)sender {
    ImageContainerView *view = [[ImageContainerView alloc] initWithAttributes:[GenericContainerViewHelper defaultImageAttributes]];
    [view applyAttributes:[GenericContainerViewHelper defaultImageAttributes]];
    view.delegate = self;
    [view becomeFirstResponder];
    [self.canvas addSubview:view];
}

- (IBAction)addText:(id)sender {
    TextContainerView *view = [[TextContainerView alloc] initWithAttributes:[GenericContainerViewHelper defaultTextAttributes]];
    view.delegate = self;
    [view startEditing];
    [view becomeFirstResponder];
    [self.canvas addSubview:view];
}

#pragma mark - ContentContainerViewDelegate
- (void) contentViewWillResignFirstResponder:(GenericContainerView *)contentView
{
    
}

- (void) contentViewDidResignFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = nil;
    [[EditorPanelManager sharedManager] dismissAllEditorPanelsFromViewController:self];
}

- (void) contentViewWillBecomFirstResponder:(GenericContainerView *)contentView
{
    [self resignPreviousFirstResponderExceptForContainer:contentView];
}

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = contentView;
    [self.canvas disablePinch];
    [[EditorPanelManager sharedManager] showEditorPanelInViewController:self forContentView:contentView];
}

- (void) contentView:(GenericContainerView *)contentView didChangeAttributes:(NSDictionary *)attributes
{
    [[EditorPanelManager sharedManager] makeCurrentEditorApplyChanges:attributes];
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
    self.canvas.transform = CGAffineTransformTranslate(self.canvas.transform, 0, -1 * self.offsetForKeyboard);
    self.offsetForKeyboard = 0;
}

- (void) adjustCanvasSizeAndPosition
{
    CGFloat offset = [EditorPanelManager currentEditorWidth] + GAP_BETWEEN_VIEWS;
    CGFloat scale = (self.canvas.bounds.size.width - offset) / self.canvas.bounds.size.width;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    transform = CGAffineTransformTranslate(transform, (-1 * offset +  GAP_BETWEEN_VIEWS) * scale, 0);
    self.canvas.transform = transform;
}

- (void) adjustCanvasPositionForContentBottom:(CGFloat) contentBottom
{
    CGPoint bottomPoint = [self.view convertPoint:CGPointMake(0, contentBottom) fromView:self.canvas];
    if (bottomPoint.y + GAP_BETWEEN_VIEWS > self.keyboardOriginY) {
        self.offsetForKeyboard = (self.keyboardOriginY -bottomPoint.y - GAP_BETWEEN_VIEWS) / self.canvas.transform.a;
        self.canvas.transform = CGAffineTransformTranslate(self.canvas.transform, 0, self.offsetForKeyboard);
    }
}

- (IBAction)addCustomTextView:(id)sender {
    CustomTapTextView *text = [[CustomTapTextView alloc] initWithFrame:CGRectMake(200, 200, 300, 300)];
    [self.canvas addSubview:text];
}

#pragma mark - Undo and Redo
- (IBAction)undo:(UIBarButtonItem *)sender {
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

@end
