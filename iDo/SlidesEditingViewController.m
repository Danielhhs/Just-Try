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
#import "RotationHelper.h"
#import "EditMenuManager.h"
#import "ColorSelectionManager.h"
#import "AnimationAttributesHelper.h"
#import "AnimationOrderManager.h"
@interface SlidesEditingViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, OperationTarget>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation SlidesEditingViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) saveSlideAttributes
{
    [self resignPreviousFirstResponderExceptForContainer:nil];
    [[SlideAttributesManager sharedManager] saveCanvasContents:self.canvas toSlide:self.slideAttributes];
}

- (void) setCanvas:(CanvasView *)canvas
{
    [_canvas removeFromSuperview];
    _canvas = canvas;
    [self.view addSubview:canvas];
}

#pragma mark - ContentContainerViewDelegate
- (void) textViewDidSelectTextRange:(NSRange)selectedRange
{
    [[EditorPanelManager sharedManager] contentViewDidSelectRange:selectedRange];
}

- (void) contentViewDidResignFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = nil;
    [[EditMenuManager sharedManager] hideEditMenu];
}

- (void) contentViewWillBecomFirstResponder:(GenericContainerView *)contentView
{
    [self resignPreviousFirstResponderExceptForContainer:contentView];
}

- (void) contentViewDidBecomFirstResponder:(GenericContainerView *)contentView
{
    self.currentSelectedContent = contentView;
    [self.canvas disablePinch];
    [self.view bringSubviewToFront:[EditMenuManager sharedManager].editMenu];
    [self.delegate contentViewDidBecomeFirstResponder:contentView];
}

- (void) contentView:(GenericContainerView *)contentView didChangeAttributes:(NSDictionary *)attributes
{
    [self.delegate contentDidChangeFromEditingController:self];
}

- (void) contentView:(GenericContainerView *)content willBeModifiedInCanvas:(CanvasView *)canvas
{
    [self.delegate contentView:content willBeModifiedInCanvas:canvas];
}

- (void) contentViewDidPerformUndoRedoOperation:(GenericContainerView *)content
{
    [self.delegate contentViewDidPerformUndoRedoOperation:content];
}

- (void) contentView:(GenericContainerView *)contentView startChangingAttribute:(NSString *) attribute
{
    [[EditMenuManager sharedManager] hideEditMenu];
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

- (void) textViewDidSelectFont:(UIFont *)font
{
    [[EditorPanelManager sharedManager] textViewDidSelectFont:font];
}

#pragma mark - EditorPanelContainerViewControllerDelegate
- (void) editorContainerViewController:(EditorPanelContainerViewController *)container didChangeAttributes:(NSDictionary *)attributes
{
    [self.currentSelectedContent applyChanges:attributes];
}

#pragma mark - TextEditorPanelViewController

- (void) textAttributes:(NSDictionary *)textAttributes didChangeFromTextEditor:(TextEditorPanelContainerViewController *)textEditor
{
    [self.currentSelectedContent applyChanges:textAttributes];
}

- (void) textEditorDidSelectNonBasicEditor:(TextEditorPanelContainerViewController *)textEditorController
{
    [((TextContainerView *)self.currentSelectedContent) finishEditing];
}

- (void) showColorPickerForColor:(UIColor *) color
{
    [self.currentSelectedContent endEditing:YES];
    [[ColorSelectionManager sharedManager] showColorPickerFromRect:self.currentSelectedContent.frame inView:self.canvas forType:ColorUsageTypeTextColor selectedColor:color];
}

- (void) changeTextContainerBackgroundColor:(UIColor *)color
{
    [self.currentSelectedContent changeBackgroundColor:color];
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
    [[EditMenuManager sharedManager] showEditMenuToView:canvas];
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

#pragma mark - Add & Remove Contents
- (void) addContentViewToCanvas:(GenericContainerView *)content
{
    content.delegate = self;
    content.canvas = self.canvas;
    [self.canvas addSubview:content];
    content.center = [self canvasCenter];
    [content becomeFirstResponder];
    [[SlideAttributesManager sharedManager] addNewContent:[content attributes] toSlide:self.slideAttributes];
    self.slideAttributes.thumbnail = [self.canvas snapshot];
}

- (void) removeCurrentContentViewFromCanvas
{
    GenericContainerView *content = self.currentSelectedContent;
    [self.currentSelectedContent resignFirstResponder];
    [content removeFromSuperview];
    [[EditMenuManager sharedManager] hideEditMenu];
    [self.delegate contentDidChangeFromEditingController:self];
}

- (CGPoint) canvasCenter
{
    CGPoint center;
    center.x = CGRectGetMidX(self.canvas.bounds);
    center.y = CGRectGetMidY(self.canvas.bounds);
    return center;
}

#pragma mark - AnimationEditorContainerViewControllerDelegate
- (void) animationEditorDidSelectAnimation:(AnimationDescription *)animation
{
    [AnimationAttributesHelper updateContent:self.currentSelectedContent withAnimationDescription:animation generatingOperation:YES];
    NSInteger animationIndex = animation.animationIndex;
    if (animation.animationEffect == AnimationEffectNone) {
        animationIndex = -1;
    }
    [[EditMenuManager sharedManager] updateEditMenuWithView:self.currentSelectedContent];
    [[AnimationOrderManager sharedManager] applyAnimationOrderIndicatorToView:self.currentSelectedContent];
}

- (void) animationEditorDidUpdateAnimationEffect:(AnimationDescription *) animation
{
    [[SlideAttributesManager sharedManager] updateSlideWithAnimationDescription:animation content:self.currentSelectedContent];
    NSInteger animationIndex = animation.animationIndex;
    if (animation.animationEffect == AnimationEffectNone) {
        animationIndex = -1;
    }
    [[EditMenuManager sharedManager] updateEditMenuWithAnimationName:animation.animationName animationOrder:animationIndex forContent:self.currentSelectedContent];
    [[AnimationOrderManager sharedManager] applyAnimationOrderIndicatorToView:self.currentSelectedContent];
}

- (void) animationEditorDidSwitchAnimationAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [[SlideAttributesManager sharedManager] switchAnimationAtIndex:fromIndex toIndex:toIndex];
    [[EditMenuManager sharedManager] updateEditMenuWithView:self.currentSelectedContent];
    [[AnimationOrderManager sharedManager] applyAnimationOrderIndicatorToView:self.currentSelectedContent];
}

@end
