//
//  AnimationDirectionSelectionView.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationDirectionSelectionView.h"
#import "AnimationDirectionArrowView.h"
#define kVerticalArrowHeight 30
#define kTopBottomSpace 10
#define kHorizontalArrowWidth 50
#define kLeftRightSpace 20
#define kRectengularWidth 78
#define kRectangularHeight 60

#define kViewWidth 40
@interface AnimationDirectionSelectionView()<AnimationDirectionArrowViewDelegate>
@property (nonatomic, strong) AnimationDirectionArrowView *topArrow;
@property (nonatomic, strong) AnimationDirectionArrowView *bottomArrow;
@property (nonatomic, strong) AnimationDirectionArrowView *leftArrow;
@property (nonatomic, strong) AnimationDirectionArrowView *rightArrow;
@end

@implementation AnimationDirectionSelectionView

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    self.topArrow = [[AnimationDirectionArrowView alloc] initWithFrame:CGRectMake(midX - kViewWidth / 2, kTopBottomSpace, kViewWidth, kVerticalArrowHeight) direction:AnimationPermittedDirectionUp delegate:self];
    self.bottomArrow = [[AnimationDirectionArrowView alloc] initWithFrame:CGRectMake(midX - kViewWidth / 2, kTopBottomSpace + kVerticalArrowHeight + kRectangularHeight, kViewWidth, kVerticalArrowHeight) direction:AnimationPermittedDirectionBottom delegate:self];
    self.leftArrow = [[AnimationDirectionArrowView alloc] initWithFrame:CGRectMake(kLeftRightSpace, midY - kViewWidth / 2, kHorizontalArrowWidth, kViewWidth) direction:AnimationPermittedDirectionLeft delegate:self];
    self.rightArrow = [[AnimationDirectionArrowView alloc] initWithFrame:CGRectMake(kLeftRightSpace + kHorizontalArrowWidth + kRectengularWidth, midY - kViewWidth / 2, kHorizontalArrowWidth, kViewWidth) direction:AnimationPermittedDirectionRight delegate:self];
    [self addSubview:self.topArrow];
    [self addSubview:self.bottomArrow];
    [self addSubview:self.leftArrow];
    [self addSubview:self.rightArrow];
}

- (void) setPermittedDirection:(AnimationPermittedDirection)permittedDirection
{
    _permittedDirection = permittedDirection;
    self.topArrow.allowed = (permittedDirection & AnimationPermittedDirectionUp) ? YES : NO;
    self.bottomArrow.allowed = (permittedDirection & AnimationPermittedDirectionBottom) ? YES : NO;
    self.leftArrow.allowed = (permittedDirection & AnimationPermittedDirectionLeft) ? YES : NO;
    self.rightArrow.allowed = (permittedDirection & AnimationPermittedDirectionRight) ? YES : NO;
}

- (void) setSelectedDirection:(AnimationPermittedDirection)selectedDirection
{
    _selectedDirection = selectedDirection;
    self.topArrow.selected = (selectedDirection & AnimationPermittedDirectionUp) ? YES : NO;
    self.bottomArrow.selected = (selectedDirection & AnimationPermittedDirectionBottom) ? YES : NO;
    self.leftArrow.selected = (selectedDirection & AnimationPermittedDirectionLeft) ? YES : NO;
    self.rightArrow.selected = (selectedDirection & AnimationPermittedDirectionRight) ? YES :NO;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *centerRect = [UIBezierPath bezierPathWithRect:CGRectMake(kLeftRightSpace + kHorizontalArrowWidth, kTopBottomSpace + kVerticalArrowHeight, kRectengularWidth, kRectangularHeight)];
    [self.tintColor setStroke];
    [centerRect stroke];
}

#pragma mark - AnimationDirectionArrowViewDelegate
- (void) didSelectDirection:(AnimationPermittedDirection)direction
{
    self.selectedDirection = direction;
}

@end
