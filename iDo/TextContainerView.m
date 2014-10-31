//
//  TextContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContainerView.h"
#import "UIView+Snapshot.h"
#import "TextDisplayView.h"
#import "CoreTextHelper.h"
#import "GenericContainerViewHelper.h"

@interface TextContainerView ()<UITextViewDelegate, TextDisplayViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) TextDisplayView *textDisplayView;
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
    self.textDisplayView = [[TextDisplayView alloc] initWithFrame:CGRectZero attributes:attributes correspondintTextView:self.textView delegate:self];
    [self adjustTextViewFrameAndContainerFrame];
}

- (void) setupTextViewWithAttributedString:(NSDictionary *) attributes
{
    self.textView = [[UITextView alloc] initWithFrame:[self contentViewFrame]];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.attributedText = attributes[[GenericContainerViewHelper attibutedStringKey]];
    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    self.textView.hidden = YES;
    self.textView.allowsEditingTextAttributes = YES;
    UITapGestureRecognizer *tapToLocate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLocate:)];
    [self.textView addGestureRecognizer:tapToLocate];
}

- (void) addSubViews
{
    [self addSubview:self.textDisplayView];
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
    self.textDisplayView.frame = [self contentViewFrame];
    self.textView.frame = [self contentViewFrame];
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
    self.textDisplayView.userInteractionEnabled = NO;
    self.textView.hidden = YES;
    self.textDisplayView.hidden = NO;
    [self.textView resignFirstResponder];
    [super updateReflectionView];
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self.delegate contentViewDidBecomFirstResponder:self];
    [self updateEditingStatus];
    return result;
}

- (void) tapToEdit:(UITapGestureRecognizer *) tap
{
    [self startEditing];
}

- (void) tapToLocate:(UITapGestureRecognizer *) tap
{
    NSLayoutManager *layoutManager = [self.textView layoutManager];
    CGPoint location = [tap locationInView:self.textView];
    location.x -= self.textView.textContainerInset.left;
    location.y -= self.textView.textContainerInset.top;
    
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:location inTextContainer:self.textView.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    if (characterIndex < [self.textView.textStorage length]) {
        self.textView.selectedRange = NSMakeRange(characterIndex + 1, 0);
    }
    NSRange range;
    if (characterIndex == 0) {
        range = NSMakeRange(characterIndex, 1);
    } else {
        range = NSMakeRange(characterIndex - 1, 1);
    }
    if (characterIndex > 0) {
        characterIndex = characterIndex - 1;
    }
    UIFont *font = [[self.textView.attributedText attributesAtIndex:characterIndex effectiveRange:&range] objectForKey:NSFontAttributeName];
    [self.delegate contentView:self didChangeAttributes:@{[GenericContainerViewHelper fontKey] : font}];
}

- (void) startEditing
{
    self.textDisplayView.hidden = YES;
    self.textView.hidden = NO;
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void) textViewDidChange:(UITextView *)textView
{
    [self adjustTextViewFrameAndContainerFrame];
    [self updateReflectionView];
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
    UIFont *font = [attributes objectForKey:[GenericContainerViewHelper fontKey]];
    if (font) {
        [attributedString enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
        }];
        self.textView.attributedText = attributedString;
        [self.textView select:self];
        self.textView.selectedRange = selectedRange;
        [self adjustTextViewFrameAndContainerFrame];
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
    if (self.textDisplayView.hidden == NO) {
        return [self.textDisplayView snapshot];
    } else {
        return [self.textView snapshot];
    }
}

- (void) updateEditingStatus
{
    [super updateEditingStatus];
    if (CGAffineTransformIsIdentity(self.transform)) {
        self.textDisplayView.userInteractionEnabled = YES;
    } else {
        self.textDisplayView.userInteractionEnabled = NO;
    }
}

#pragma mark - TextDisplayViewDelegate
- (void) handleTapOnTextDisplayView:(TextDisplayView *)textDisplayView
{
    [self startEditing];
}

@end
