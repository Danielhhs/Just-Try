//
//  TooltipView.m
//  iDo
//
//  Created by Huang Hongsen on 10/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TooltipView.h"

#define ARROW_WIDTH_HALF 10
#define ARROW_HEIGHT 10
#define TOOLTIP_CORNER_RADIUS 10
#define TOOLTIP_ALHPA 0.618

@interface TooltipView()
@property (nonatomic, strong) UILabel *label;
@end

@implementation TooltipView

- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = TOOLTIP_ALHPA;
    self.label = [[UILabel alloc] initWithFrame:[self frameForLabel]];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    [self addSubview:self.label];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setToolTipText:(NSString *)toolTipText
{
    _toolTipText = toolTipText;
    self.label.text = toolTipText;
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    [path moveToPoint:CGPointMake(midX, 0)];
    [path addLineToPoint:CGPointMake(midX + ARROW_WIDTH_HALF, ARROW_HEIGHT)];
    
    CGPoint center = CGPointMake(maxX - TOOLTIP_CORNER_RADIUS, ARROW_HEIGHT + TOOLTIP_CORNER_RADIUS);
    [path addLineToPoint:CGPointMake(center.x, ARROW_HEIGHT)];
    [path addArcWithCenter:center radius:TOOLTIP_CORNER_RADIUS startAngle:1.5*M_PI endAngle:M_PI * 2 clockwise:YES];
    
    center.y = maxY - TOOLTIP_CORNER_RADIUS;
    [path addLineToPoint:CGPointMake(maxX, center.y)];
    [path addArcWithCenter:center radius:TOOLTIP_CORNER_RADIUS startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    center.x = TOOLTIP_CORNER_RADIUS;
    [path addLineToPoint:CGPointMake(center.x, maxY)];
    [path addArcWithCenter:center radius:TOOLTIP_CORNER_RADIUS startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    center.y = ARROW_HEIGHT + TOOLTIP_CORNER_RADIUS;
    [path addLineToPoint:CGPointMake(0, center.y)];
    [path addArcWithCenter:center radius:TOOLTIP_CORNER_RADIUS startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(midX - ARROW_WIDTH_HALF, ARROW_HEIGHT)];
    [path closePath];
    
    [[UIColor darkTextColor] setFill];
    [path fill];
}

#pragma mark - Private Helper
- (CGRect) frameForLabel
{
    return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - ARROW_HEIGHT);
}

@end
