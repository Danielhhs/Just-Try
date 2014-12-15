//
//  AnimationParameterSlider.m
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationParameterSlider.h"
#import "TooltipView.h"
@interface AnimationParameterSlider()
@property (nonatomic, strong) TooltipView *tooltip;
@end
#define THUMB_WIDTH_HALF 15
@implementation AnimationParameterSlider

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.tooltip = [[TooltipView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    self.tooltip.hidden = YES;
    [self addSubview:self.tooltip];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self updateToolTip];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self updateToolTip];
}

- (void) updateToolTip
{
    self.tooltip.hidden = NO;
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:[self bounds] trackRect:trackRect value:self.value];
    self.tooltip.toolTipText = [NSString stringWithFormat:@"%3.2f", self.value];
    CGPoint position = [self tooltipCenterFromThumbPosition:thumbRect.origin];
    self.tooltip.center = [self tooltipCenterFromThumbPosition:position];
}

- (CGPoint) tooltipCenterFromThumbPosition:(CGPoint) position
{
    CGPoint center;
    center.x = position.x + THUMB_WIDTH_HALF / 2;
    center.y = position.y - self.bounds.size.height / 2;
    return center;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.tooltip.hidden = YES;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.tooltip.hidden = YES;
}

@end
