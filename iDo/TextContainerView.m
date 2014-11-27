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
#import "DrawingConstants.h"

@interface TextContainerView ()<CustomTapTextViewDelegate>
@property (nonatomic, strong) CustomTapTextView *textView;
@property (nonatomic) NSRange lastSelectedRange;
@property (nonatomic, strong) NSAttributedString *lastAttrText;
@property (nonatomic) BOOL selected;
@end

@implementation TextContainerView

- (instancetype) initWithAttributes:(NSDictionary *) attributes delegate:(id<ContentContainerViewDelegate>)delegate
{
    self = [super initWithAttributes:attributes delegate:delegate];
    if (self) {
        [self setupTextViewWithAttributedString:attributes];
        [self addSubViews];
        [GenericContainerViewHelper applyUndoAttribute:attributes toContainer:self];
        [self adjustTextViewBoundsForBounds:self.bounds];
    }
    return self;
}

- (void) setupTextViewWithAttributedString:(NSDictionary *) attributes
{
    CGRect bounds = [attributes[[KeyConstants boundsKey]] CGRectValue];
    self.textView = [[CustomTapTextView alloc] initWithFrame:[self contentViewFrameFromBounds:bounds] attributes:self.attributes];
    self.textView.delegate = self;
    self.lastSelectedRange = self.textView.selectedRange;
    self.lastAttrText = self.textView.attributedText;
}

- (void) addSubViews
{
    [self addSubview:self.textView];
    [super addSubViews];
}

- (void) setBounds:(CGRect)bounds
{
    [self adjustTextViewBoundsForBounds:bounds];
    CGRect boundsAfterAdjustments = [self boundsFromTextViewBounds:self.textView.bounds];
    [super setBounds:boundsAfterAdjustments];
//    [GenericContainerViewHelper mergeChangedAttributes:@{[KeyConstants boundsKey] : [NSValue valueWithCGRect:boundsAfterAdjustments]} withFullAttributes:self.attributes];
    if ([self needToAdjustCanvas]) {
        [self.delegate frameDidChangeForContentView:self];
    }
}

- (void) setSelected:(BOOL)selected
{
    if (selected != _selected) {
        _selected = selected;
        [self setNeedsDisplay];
    } else {
        _selected = selected;
    }
}

- (BOOL) needToAdjustCanvas
{
    return [self.textView isFirstResponder];
}

- (CGRect) contentViewFrameFromBounds:(CGRect) bounds
{
    CGRect frame = [super contentViewFrameFromBounds:bounds];
    return CGRectInset(frame, [DrawingConstants controlPointRadius], [DrawingConstants controlPointRadius]);
}

#pragma mark - User Interactions
- (BOOL) resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    self.selected = NO;
    [self.textView finishEditing];
    self.bounds = self.bounds;
    [super updateReflectionView];
    [self createTextOperationAndPushToUndoManager];
    [GenericContainerViewHelper mergeChangedAttributes:@{[KeyConstants attibutedStringKey] : self.textView.attributedText} withFullAttributes:self.attributes];
    [self.delegate contentView:self didChangeAttributes:nil];
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self.textView readyToEdit];
    self.selected = YES;
    [self.delegate contentViewDidBecomFirstResponder:self];
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
    self.bounds = self.bounds;
    [self updateReflectionView];
}

- (void) textViewWillChangeSelection:(CustomTapTextView *)textView
{
    [self createTextOperationAndPushToUndoManager];
}

- (void) textView:(CustomTapTextView *)textView didSelectFont:(UIFont *)font
{
    self.bounds = self.bounds;
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

- (void) createTextOperationAndPushToUndoManager
{
    if (![self.textView.attributedText isEqualToAttributedString:self.lastAttrText]) {
        [self pushOperationToUndoManagerAndUpdateTextStatus];
    }
}

- (SimpleOperation *) selectionOperation
{
    SimpleOperation *selectionOperation;
    NSInteger toRangeLocation = MIN(self.lastSelectedRange.location, self.textView.selectedRange.location);
    NSUInteger toRangeLength;
    if (self.textView.selectedRange.location > self.lastSelectedRange.location) {
        selectionOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants textSelectionKey] fromValue:[NSValue valueWithRange:self.lastSelectedRange]];
        toRangeLength = self.textView.selectedRange.location - self.lastSelectedRange.location;
        NSRange toRange = NSMakeRange(toRangeLocation, toRangeLength);
        selectionOperation.toValue = [NSValue valueWithRange:toRange];
    } else {
        toRangeLength = self.lastSelectedRange.location - self.textView.selectedRange.location;
        NSRange toRange = NSMakeRange(toRangeLocation, toRangeLength);
        selectionOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:[KeyConstants textSelectionKey] fromValue:[NSValue valueWithRange:toRange]];
        selectionOperation.toValue = [NSValue valueWithRange:self.lastSelectedRange];
    }
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
    self.bounds = self.bounds;
}

- (void) adjustTextViewBoundsForBounds:(CGRect) bounds
{
    self.textView.frame = [self contentViewFrameFromBounds:bounds];
    CGFloat height = [CoreTextHelper heightForAttributedStringInTextView:self.textView];
    self.textView.bounds = CGRectMake(0, 0, self.textView.bounds.size.width, height);
    self.textView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (CGRect) boundsFromTextViewBounds:(CGRect) textViewBounds
{
    CGRect bounds;
    bounds.origin = CGPointMake(0, 0);
    bounds.size.width = textViewBounds.size.width + 2 * [DrawingConstants controlPointSizeHalf] + 2 * [DrawingConstants controlPointRadius];
    bounds.size.height = 2 * [DrawingConstants controlPointSizeHalf] + textViewBounds.size.height + 2 * [DrawingConstants controlPointRadius];
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
        self.bounds = self.bounds;
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
        self.bounds = self.bounds;
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

- (UIImage *) contentSnapshot
{
    return [self.textView snapshot];
}

- (void) performOperation:(SimpleOperation *)operation
{
    [super performOperation:operation];
    if (operation.toValue) {
        [self applyTextAttributes:@{operation.key : operation.toValue}];
        [self applyFontAttribute:@{operation.key : operation.toValue}];
    }
    [self.delegate contentViewDidPerformUndoRedoOperation:self];
}

- (void) pushUnsavedOperation
{
    [self.textView resignFirstResponder];
    [self createTextOperationAndPushToUndoManager];
}

- (UIView *) contentView
{
    return self.textView;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:[[ControlPointManager sharedManager] borderRectFromContainerViewBounds:rect]];
    
    borderPath.lineWidth = 3.f;
    [[self borderStrokeColor] setStroke];
    [borderPath stroke];
}

- (UIColor *) borderStrokeColor
{
    return self.selected ? [[ControlPointManager sharedManager] borderColor] : [UIColor clearColor];
}
@end
