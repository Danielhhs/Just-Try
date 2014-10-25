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
    self.textView.backgroundColor = [UIColor blackColor];
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
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, self.textView.bounds.size.height)];
    self.textView.bounds = CGRectMake(0, 0, self.textView.bounds.size.width, size.height);
    self.frame = [self frameFromTextViewBounds:[self.textView bounds]];
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
    NSMutableAttributedString *attributedString = [self.textView.attributedText mutableCopy];
    NSRange selectedRange = self.textView.selectedRange;
    
    [self applyFontNameAttribute:attributes toAttributedString:attributedString inRange:selectedRange];
    [self applyFontSizeAttribute:attributes toAttributedString:attributedString inRange:selectedRange];
    
    self.textView.attributedText = attributedString;
    [self adjustTextViewFrameAndContainerFrame];
}

- (void) applyFontNameAttribute:(NSDictionary *) attributes
             toAttributedString:(NSMutableAttributedString *) attributedString
                        inRange:(NSRange) selectedRange
{
    NSString *fontName = [attributes objectForKey:[GenericContainerViewHelper fontKey]];
    if (fontName) {
        [attributedString enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            UIFont *oldFont = (UIFont *) value;
            UIFont *newFont = [UIFont fontWithName:fontName size:oldFont.pointSize];
            [attributedString addAttribute:NSFontAttributeName value:newFont range:range];
        }];
    }
}

- (void) applyFontSizeAttribute:(NSDictionary *) attributes
            toAttributedString:(NSMutableAttributedString *) attributedString
                       inRange:(NSRange) selectedRange
{
    NSNumber *fontSize = [attributes objectForKey:[GenericContainerViewHelper fontSizeKey]];
    if (fontSize) {
        [attributedString enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            UIFont *oldFont = (UIFont *) value;
            UIFont *newFont = [UIFont fontWithName:oldFont.fontName size:[fontSize doubleValue]];
            [attributedString addAttribute:NSFontAttributeName value:newFont range:range];
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
