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

@interface TextContainerView ()<CustomTapTextViewDelegate>
@property (nonatomic, strong) CustomTapTextView *textView;
@end

@implementation TextContainerView

- (instancetype) initWithAttributes:(NSDictionary *) attributes
{
    self = [super initWithAttributes:attributes];
    if (self) {
        [self setupSubViewsWithAttributes:attributes];
        [self addSubViews];
    }
    return self;
}

- (void) setupSubViewsWithAttributes:(NSDictionary *) attributes
{
    [self setupTextViewWithAttributedString:attributes];
    [self adjustTextViewFrameAndContainerFrame];
}

- (void) setupTextViewWithAttributedString:(NSDictionary *) attributes
{
    self.textView = [[CustomTapTextView alloc] initWithFrame:[self contentViewFrame] attributes:self.attributes];
    self.textView.delegate = self;
}

- (void) addSubViews
{
    [self addSubview:self.textView];
    [super addSubViews];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textView.frame = [self contentViewFrame];
    CGFloat height = [CoreTextHelper heightForAttributedStringInTextView:self.textView];
    CGRect bounds = CGRectMake(0, 0, frame.size.width, height);
    [super setFrame:[self frameFromTextViewBounds:bounds]];
    self.textView.frame = [self contentViewFrame];
    if ([self needToAdjustCanvas]) {
        [self.delegate frameDidChangeForContentView:self];
    }
}

- (BOOL) needToAdjustCanvas
{
    BOOL withinSuperView = CGRectGetMaxY(self.frame) <= self.superview.bounds.size.height;
    return self.textView.editable == YES && withinSuperView;
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
    [self.textView finishEditing];
    [super updateReflectionView];
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self.textView readyToEdit];
    [self.delegate contentViewDidBecomFirstResponder:self];
    [self updateEditingStatus];
    return result;
}

- (void) startEditing
{
    [self.textView becomeFirstResponder];
}

#pragma mark - CustomTextViewDelegate
-(void) textViewDidChange:(UITextView *)textView
{
    [self adjustTextViewFrameAndContainerFrame];
    [self updateReflectionView];
}

- (void) textView:(CustomTapTextView *)textView didSelectFont:(UIFont *)font
{
    [self.delegate contentView:self didChangeAttributes:@{[KeyConstants fontKey] : font}];
}

- (void) adjustTextViewFrameAndContainerFrame
{
    CGFloat height = [CoreTextHelper heightForAttributedStringInTextView:self.textView];
    self.textView.bounds = CGRectMake(0, 0, self.textView.bounds.size.width, height);
    self.frame = [self frameFromTextViewBounds:[self.textView bounds]];
}

- (CGRect) frameFromTextViewBounds:(CGRect) textViewBounds
{
    CGRect frame;
    frame.origin.x = self.frame.origin.x;
    frame.origin.y = self.frame.origin.y;
    frame.size.width = self.frame.size.width;
    frame.size.height = 2 * CONTROL_POINT_SIZE_HALF + textViewBounds.size.height + 2 * CONTROL_POINT_RADIUS;
    return frame;
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    [super applyAttributes:attributes];
    [self applyFontAttribute:attributes];
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
        [self adjustTextViewFrameAndContainerFrame];
    }
    NSNumber *alignment = [attributes objectForKey:[KeyConstants alignmentKey]];
    if (alignment) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = [alignment integerValue];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        self.textView.attributedText = attributedString;
    }
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

- (void) updateEditingStatus
{
    [super updateEditingStatus];
    if (CGAffineTransformIsIdentity(self.transform)) {
        self.textView.userInteractionEnabled = YES;
    } else {
        self.textView.userInteractionEnabled = NO;
    }
}

@end
