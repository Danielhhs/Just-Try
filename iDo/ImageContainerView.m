//
//  ImageContainerView.m
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ImageContainerView.h"
#import "UIView+Snapshot.h"
#import "GenericContainerViewHelper.h"
#import "KeyConstants.h"

@interface ImageContainerView()
@property (nonatomic, strong) UIImageView *imageContent;
@end

@implementation ImageContainerView

- (instancetype) initWithAttributes:(NSDictionary *)attributes delegate:(id<ContentContainerViewDelegate>)delegate
{
    self = [super initWithAttributes:attributes delegate:delegate];
    if (self) {
        _image = [UIImage imageNamed:attributes[[KeyConstants imageNameKey]]];
        [self setUpImageContentWithImage:_image];
        [self addSubViews];
        [self hideRotationIndicator];
        [GenericContainerViewHelper applyUndoAttribute:attributes toContainer:self];
    }
    return self;
}

- (void) setUpImageContentWithImage:(UIImage *) image
{
    self.imageContent = [[UIImageView alloc] initWithImage:image];
    self.imageContent.frame = [self contentViewFrameFromBounds:self.bounds];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [self.imageContent addGestureRecognizer:doubleTap];
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    self.imageContent.image = image;
}

- (void) addSubViews
{
    [self addSubview:self.imageContent];
    [super addSubViews];
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.imageContent.frame = [self contentViewFrameFromBounds:self.bounds];
    [GenericContainerViewHelper mergeChangedAttributes:@{[KeyConstants boundsKey] : [NSValue valueWithCGRect:bounds]} withFullAttributes:self.attributes];
}

#pragma mark - User Interactions

- (BOOL) resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    [self.imageContent setUserInteractionEnabled:NO];
    [self.delegate contentViewDidResignFirstResponder:self];
    return result;
}

- (BOOL) becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    [self.imageContent setUserInteractionEnabled:YES];
    [self.delegate contentViewDidBecomFirstResponder:self];
    [self updateEditingStatus];
    return result;
}

- (void) changeImage:(UITapGestureRecognizer *) tap
{
    [self.delegate handleTapOnImage:self];
}

- (UIImage *) contentSnapshot
{
    return [self.imageContent snapshot];
}

- (void) performOperation:(SimpleOperation *)operation
{
    [super performOperation:operation];
    [self.delegate contentView:self didChangeAttributes:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
