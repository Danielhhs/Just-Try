//
//  ViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlidesEditingViewController.h"
#import "TooltipView.h"
#import "EditorPanelManager.h"
#import "CanvasView.h"
#import "CustomTapTextView.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "KeyConstants.h"
#import "UIView+Snapshot.h"
#import "SlideAttributesManager.h"
#import "ContentEditMenuView.h"

@interface SlidesEditingViewController ()<CanvasViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, OperationTarget>
@property (strong, nonatomic) CanvasView *canvas;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic) NSUInteger currentSelectionOriginalIndex;
@property (nonatomic, strong) ContentEditMenuView *editMenu;
@end

@implementation SlidesEditingViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.canvas = [[CanvasView alloc] initWithAttributes:self.slideAttributes delegate:self contentDelegate:self];
    self.canvas.delegate = self;
    self.editMenu = [[ContentEditMenuView alloc] initWithFrame:CGRectZero];
    [self.canvas addSubview:self.editMenu];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.canvas];
}

- (void) setSlideAttributes:(NSMutableDictionary *)slideAttributes
{
    _slideAttributes = slideAttributes;
    [self.canvas setupWithAttributes:slideAttributes];
}

- (void) updateCanvasWithSlide:(NSMutableDictionary *)slide
{
    self.slideAttributes = slide;
}

- (void) saveSlideAttributes
{
    [self resignPreviousFirstResponderExceptForContainer:nil];
    [[SlideAttributesManager sharedManager] saveCanvasContents:self.canvas toSlide:self.slideAttributes];
}

#pragma mark - ContentContainerViewDelegate
- (void) textViewDidSelectTextRange:(NSRange)selectedRange
{
    [[EditorPanelManager sharedManager] contentViewDidSelectRange:selectedRange];
}

- (void) contentViewDidResignFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = nil;
    [self.editMenu hide];
    [self switchView:contentView toIndex:self.currentSelectionOriginalIndex inSuperView:self.canvas];
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
    self.editMenu.triggeredContent = contentView;
    [self.editMenu show];
    [self.canvas bringSubviewToFront:self.editMenu];
    [self.delegate contentViewDidBecomeFirstResponder:contentView];
}

- (void) contentView:(GenericContainerView *)contentView didChangeAttributes:(NSDictionary *)attributes
{
    if (attributes) {
        [[EditorPanelManager sharedManager] makeCurrentEditorApplyChanges:attributes];
    }
    [self.slideAttributes setValue:[self.canvas snapshot] forKey:[KeyConstants slideThumbnailKey]];
    [self.delegate contentDidChangeFromEditingController:self];
    [[UndoManager sharedManager] clearRedoStack];
}

- (void) contentView:(GenericContainerView *)contentView startChangingAttributes:(NSDictionary *)attribtues
{
    [self.editMenu hide];
}

- (void) frameDidChangeForContentView:(GenericContainerView *)contentView
{
    CGFloat contentBottom = CGRectGetMaxY(contentView.frame);
    [self.delegate adjustCanvasPositionForContentBottom:contentBottom];
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
    [popOver presentPopoverFromRect:container.frame
                             inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny
                           animated:YES];
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
    [self.delegate allContentViewDidResignFirstResponder];
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
    [superView insertSubview:view atIndex:index];
}

#pragma mark - Add & Remove Contents
- (void) addContentViewToCanvas:(GenericContainerView *)content
{
    [self.canvas addSubview:content];
    content.center = [self canvasCenter];
    [content becomeFirstResponder];
    [[SlideAttributesManager sharedManager] addNewContent:[content attributes] toSlide:self.slideAttributes];
    [self.slideAttributes setObject:[self.canvas snapshot] forKey:[KeyConstants slideThumbnailKey]];
}

- (void) removeCurrentContentViewFromCanvas
{
    [self.currentSelectedContent resignFirstResponder];
    [self.currentSelectedContent removeFromSuperview];
}

- (CGPoint) canvasCenter
{
    CGPoint center;
    center.x = CGRectGetMidX(self.canvas.bounds);
    center.y = CGRectGetMidY(self.canvas.bounds);
    return center;
}

#pragma mark - Edit Menu


@end
