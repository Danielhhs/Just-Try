//
//  TextContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextContainerView.h"

#define DEFAULT_TEXT_CONTAINER_WIDTH 300.f
#define DEFAULT_TEXT_CONTAINER_HEIGHT 30
#define TEXT_VIEW_HEADER_PADDING 5.f

@interface TextContainerView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation TextContainerView

- (instancetype) initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super initWithFrame:CGRectMake(0, 0, DEFAULT_TEXT_CONTAINER_WIDTH, TOP_STICK_HEIGHT + 2 * CONTROL_POINT_SIZE_HALF + DEFAULT_TEXT_CONTAINER_HEIGHT)];
    if (self) {
        [self setupSubViewsWithAttributedString:attributedString];
        [self addSubViews];
    }
    return self;
}

- (void) setupSubViewsWithAttributedString:(NSAttributedString *) attributedString
{
    self.textLabel = [[UILabel alloc] initWithFrame:[self contentViewFrame]];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.text = attributedString.string;
    UITapGestureRecognizer *tapToEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEdit:)];
    [self.textLabel addGestureRecognizer:tapToEdit];
    
    self.textView = [[UITextView alloc] initWithFrame:[self contentViewFrame]];
    self.textView.backgroundColor = [UIColor greenColor];
    self.textView.attributedText = attributedString;
    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    self.textView.hidden = YES;
}

- (void) addSubViews
{
    [self addSubview:self.textLabel];
    [self addSubview:self.textView];
    [super addSubViews];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLabel.frame = [self contentViewFrame];
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
    self.textLabel.userInteractionEnabled = NO;
    self.textView.hidden = YES;
    self.textLabel.hidden = NO;
    [self.textView resignFirstResponder];
    self.textLabel.attributedText = self.textView.attributedText;
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    self.textLabel.userInteractionEnabled = YES;
    [self.delegate contentViewDidBecomFirstResponder:self];
    return result;
}

- (void) tapToEdit:(UITapGestureRecognizer *) tap
{
    [self startEditing];
}

- (void) startEditing
{
    self.textLabel.hidden = YES;
    self.textView.hidden = NO;
    [self.textView becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    [self adjustTextViewFrameAndContainerFrame];
    return YES;
}

- (void) adjustTextViewFrameAndContainerFrame
{
    CGFloat height = [self heightForAttributedString:self.textView.attributedText maxWidth:self.textView.bounds.size.width];
    self.textView.bounds = CGRectMake(0, 0, self.textView.bounds.size.width, height);
    self.frame = [self frameFromTextViewBounds:[self.textView bounds]];
}


- (CGFloat) heightForAttributedString:(NSAttributedString *)attrString maxWidth:(CGFloat) maxWidth
{
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [attrString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options context:nil].size;
    CGFloat height = ceilf(size.height) + 2 * TEXT_VIEW_HEADER_PADDING;
    return height;
}

- (CGRect) frameFromTextViewBounds:(CGRect) textViewBounds
{
    CGRect frame;
    frame.origin.x = self.frame.origin.x;
    frame.origin.y = self.frame.origin.y;
    frame.size.width = self.frame.size.width;
    frame.size.height = TOP_STICK_HEIGHT + 2 * CONTROL_POINT_SIZE_HALF + textViewBounds.size.height + 2 * CONTROL_POINT_RADIUS;
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

@end
