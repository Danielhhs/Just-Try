//
//  TextDisplayView.m
//  iDo
//
//  Created by Huang Hongsen on 10/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextDisplayView.h"
#import "GenericContainerViewHelper.h"
#import "CoreTextHelper.h"
#import "UIView+Snapshot.h"

#define CORE_TEXT_EXTRA_SPACE 1

@interface TextDisplayView()
@property (nonatomic, strong) UITextView *textView;
@end
@implementation TextDisplayView

#pragma mark - Initialization
- (instancetype) initWithFrame:(CGRect)frame
                    attributes:(NSDictionary *)attributes
         correspondintTextView:(UITextView *)textView
                      delegate:(id<TextDisplayViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _textView = textView;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

#pragma mark - Core Text AttributedString drawing
- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1.f);
    
    UIEdgeInsets insets = self.textView.textContainerInset;
    CGFloat maxWidth = rect.size.width - insets.left - insets.right;
    CGFloat height = [CoreTextHelper heightForAttributedString:self.textView.attributedText maxWidth:maxWidth] + 2 * CORE_TEXT_EXTRA_SPACE;
    CGRect bounds = CGRectMake(insets.left, insets.bottom + CORE_TEXT_EXTRA_SPACE, maxWidth, height);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:bounds];

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.textView.attributedText);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [self.textView.attributedText length]), bezierPath.CGPath, NULL);
    
    CFRelease(frameSetter);
    CTFrameDraw(ctFrame, context);
    CFRelease(ctFrame);
    
}

#pragma mark - User Interaction
- (void) handleTap:(UITapGestureRecognizer *) tap
{
    [self.delegate handleTapOnTextDisplayView:self];
}

- (UIImage *) snapshot
{
    [self setNeedsDisplay];
    return [super snapshot];
}

@end
