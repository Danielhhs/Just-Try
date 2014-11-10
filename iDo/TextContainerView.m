//
//  TextContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContainerView.h"
#import "UIView+Snapshot.h"
#import "CoreTextHelper.h"
#import "GenericContainerViewHelper.h"
#import "CustomTapTextView.h"
#import "KeyConstants.h"
#import "SimpleOperation.h"
#import "UndoManager.h"
#import "CompoundOperation.h"

@interface TextContainerView ()<CustomTapTextViewDelegate>
@property (nonatomic, strong) CustomTapTextView *textView;
@property (nonatomic) NSRange lastSelectedRange;
@property (nonatomic, strong) NSAttributedString *lastAttrText;
@property (nonatomic) BOOL selected;
@end

@implementation TextContainerView

- (instancetype) initWithAttributes:(NSDictionary *) attributes
{
    self = [super initWithAttributes:attributes];
    if (self) {
        [self setupSubViewsWithAttributes:attributes];
        [self addSubViews];
        [GenericContainerViewHelper applyUndoAttribute:attributes toContainer:self];
    }
    return self;
}

- (void) setupSubViewsWithAttributes:(NSDictionary *) attributes
{
    [self setupTextViewWithAttributedString:attributes];
    [self adjustTextViewBoundsAndContainerBounds];
}

- (void) setupTextViewWithAttributedString:(NSDictionary *) attributes
{
    self.textView = [[CustomTapTextView alloc] initWithFrame:[self contentViewFrame] attributes:self.attributes];
    self.textView.delegate = self;
    self.lastSelectedRange = self.textView.selectedRange;
    self.lastAttrText = self.textView.attributedText;
}

- (void) addSubViews
{
    [self addSubview:self.textView];
    [super addSubViews];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self adjustTextViewBoundsAndContainerBounds];
    if ([self needToAdjustCanvas]) {
        [self.delegate frameDidChangeForContentView:self];
    }
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if ([self needToAdjustCanvas]) {
        [self.delegate frameDidChangeForContentView:self];
    }
}

- (BOOL) needToAdjustCanvas
{
    return [self.textView isFirstResponder];
}

- (CGRect) contentViewFrame
{
    CGRect frame = [super contentViewFrame];
    return CGRectInset(frame, CONTROL_POINT_RADIUS, CONTROL_POINT_RADIUS);
}

#pragma mark - User Interactions
- (BOOL) resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    self.selected = NO;
    [self.textView finishEditing];
    [self adjustTextViewBoundsAndContainerBounds];
    [super updateReflectionView];
    [self createTextOperationAndPushToUndoManager];
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self.textView readyToEdit];
    self.selected = YES;
    [self.delegate contentViewDidBecomFirstResponder:self];
    [self updateEditingStatus];
    return result;
}

- (void) startEditing
{
    [self.textView becomeFirstResponder];
}

- (void) finishEditing
{
    [self.textView finishEditing];
    if (self.selected) {
        [self.textView readyToEdit];
    }
}

#pragma mark - CustomTextViewDelegate
-(void) textViewDidChange:(UITextView *)textView
{
    [self adjustTextViewBoundsAndContainerBounds];
    [self updateReflectionView];
    [self.delegate contentView:self didChangeAttributes:nil];
}

- (void) textViewWillChangeSelection:(CustomTapTextView *)textView
{
    [self createTextOperationAndPushToUndoManager];
}

- (void) textView:(CustomTapTextView *)textView didSelectFont:(UIFont *)font
{
    [self adjustTextViewBoundsAndContainerBounds];
    [self.delegate contentView:self didChangeAttributes:@{[KeyConstants fontKey] : font}];
    [self.delegate textViewDidSelectTextRange:textView.selectedRange];
    self.lastSelectedRange = self.textView.selectedRange;
}

- (void) textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.selectedRange.length != 0) {
        [self.delegate textViewDidSelectTextRange:textView.selectedRange];
        self.lastSelectedRange = textView.selectedRange;
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.lastSelectedRange = textView.selectedRange;
    [self.delegate textViewDidStartEditing:self];
    
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self createTextOperationAndPushToUndoManager];
}

- (void) createTextOperationAndPushToUndoManager
{
    if (![self.textView.attributedText isEqualToAttributedString:self.lastAttrText]) {
        [self pushOperationToUndoManagerAndUpdateTextStatus];
    }
}

- (SimpleOperation *) selectionOperation
{
    SimpleOperation *selectionOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants textSelectionKey] fromValue:[NSValue valueWithRange:self.lastSelectedRange]];
    NSRange toRange = NSMakeRange(self.lastSelectedRange.location, self.textView.selectedRange.location - self.lastSelectedRange.location);
    selectionOperation.toValue = [NSValue valueWithRange:toRange];
    return selectionOperation;
}

- (void) pushOperationToUndoManagerAndUpdateTextStatus
{
    SimpleOperation *selectionOperation = [self selectionOperation];
    SimpleOperation *textOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants attibutedStringKey] fromValue:self.lastAttrText];
    textOperation.toValue = self.textView.attributedText;
    CompoundOperation *compoundOperation = [[CompoundOperation alloc] initWithOperations:@[textOperation, selectionOperation]];
    [[UndoManager sharedManager] pushOperation:compoundOperation];
    self.lastAttrText = self.textView.attributedText;
    self.lastSelectedRange = self.textView.selectedRange;
}

- (void) textViewDidChangeAttributedText:(CustomTapTextView *)textView
{
    [self adjustTextViewBoundsAndContainerBounds];
}

- (void) adjustTextViewBoundsAndContainerBounds
{
    self.textView.frame = [self contentViewFrame];
    CGFloat height = [CoreTextHelper heightForAttributedStringInTextView:self.textView];
    self.textView.bounds = CGRectMake(0, 0, self.textView.bounds.size.width, height);
    self.bounds = [self boundsFromTextViewBounds:[self.textView bounds]];
    self.textView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (CGRect) boundsFromTextViewBounds:(CGRect) textViewBounds
{
    CGRect bounds;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    bounds.size.width = self.bounds.size.width;
    bounds.size.height = 2 * CONTROL_POINT_SIZE_HALF + textViewBounds.size.height + 2 * CONTROL_POINT_RADIUS;
    return bounds;
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    [super applyAttributes:attributes];
    [self applyTextAttributes:attributes];
    [self applyFontAttribute:attributes];
}

- (void) applyTextAttributes:(NSDictionary *) attributes
{
    NSAttributedString *attrText = [attributes objectForKey:[KeyConstants attibutedStringKey]];
    if (attrText) {
        self.textView.attributedText = attrText;
    }
    NSValue *selectedRange  = [attributes objectForKey:[KeyConstants textSelectionKey]];
    if (selectedRange) {
        self.textView.selectedRange = [selectedRange rangeValue];
    }
}

- (void) applyFontAttribute:(NSDictionary *) attributes
{
    NSMutableAttributedString *attributedString = [self.textView.attributedText mutableCopy];

    NSRange selectedRange = self.textView.selectedRange;
    UIFont *font = [attributes objectForKey:[KeyConstants fontKey]];
    if (font) {
        [attributedString enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
        }];
        self.textView.attributedText = attributedString;
        [self.textView select:self];
        self.textView.selectedRange = selectedRange;
        [self adjustTextViewBoundsAndContainerBounds];
    }
    NSNumber *alignment = [attributes objectForKey:[KeyConstants alignmentKey]];
    if (alignment) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = [alignment integerValue];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        self.textView.attributedText = attributedString;
    }
    self.lastAttrText = self.textView.attributedText;
}

#pragma mark - Override Super Class Methods
- (CGSize) minSize
{
    CGSize minSize = [super minSize];
    CGFloat height = [CoreTextHelper heightForAttributedStringInTextView:self.textView] + CONTROL_POINT_SIZE_HALF * 2;
    minSize.height = height;
    return minSize;
}

- (UIImage *) contentSnapshot
{
    return [self.textView snapshot];
}

- (void) performOperation:(SimpleOperation *)operation
{
    [super performOperation:operation];
    [self applyTextAttributes:@{operation.key : operation.toValue}];
    [self applyFontAttribute:@{operation.key : operation.toValue}];
}

- (void) pushUnsavedOperation
{
    [self createTextOperationAndPushToUndoManager];
}
@end
