//
//  CanvasAdjustmentHelper.m
//  iDo
//
//  Created by Huang Hongsen on 11/10/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "CanvasAdjustmentHelper.h"
#import "DrawingConstants.h"
#import "EditorPanelManager.h"
#import "SlideThumbnailsManager.h"

@implementation CanvasAdjustmentHelper

+ (void) adjustCanvasSizeAndPosition:(UIView *)canvas
{
    CGFloat scale = MIN([CanvasAdjustmentHelper canvasHorizontalScale], [CanvasAdjustmentHelper canvasVerticalScale]);
    canvas.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    CGFloat translateX = [CanvasAdjustmentHelper horizontalTranslationFromScale:scale];
    CGFloat translateY = [CanvasAdjustmentHelper verticalTranslationFromScale:scale];
    canvas.transform = CGAffineTransformTranslate(canvas.transform, translateX, translateY);
}

+ (CGFloat) canvasVerticalScale
{
    CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat acceptableHeight = mainScreenHeight  - [DrawingConstants topBarHeight] - 2 * [DrawingConstants gapBetweenViews];
    return acceptableHeight / mainScreenHeight;
}

+ (CGFloat) canvasHorizontalScale
{
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat inset = [[SlideThumbnailsManager sharedManager] thumbnailViewControllerWidth];
    if ([EditorPanelManager currentEditorWidth]) {
        inset = [EditorPanelManager currentEditorWidth];
    }
    CGFloat acceptableWidth = mainScreenWidth - inset - 2 * [DrawingConstants gapBetweenViews];
    return acceptableWidth / mainScreenWidth;
}

+ (CGFloat) horizontalTranslationFromScale:(CGFloat) scale
{
    if ([[SlideThumbnailsManager sharedManager] thumbnailViewControllerWidth] == 0 && [EditorPanelManager currentEditorWidth] == 0) {
        return 0;
    }
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat actualWidth = mainScreenWidth * scale;
    if ([[SlideThumbnailsManager sharedManager] thumbnailViewControllerWidth] != 0) {
        return ([[SlideThumbnailsManager sharedManager] thumbnailViewControllerWidth] + [DrawingConstants gapBetweenViews] - (mainScreenWidth - actualWidth) / 2) / scale;
        
    } else if ([EditorPanelManager currentEditorWidth] != 0) {
        return ((mainScreenWidth - actualWidth) / 2 - ([EditorPanelManager currentEditorWidth] + [DrawingConstants gapBetweenViews])) / scale;
    }
    return 0;
}

+ (CGFloat) verticalTranslationFromScale:(CGFloat) scale
{
    CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat actualHeight = mainScreenHeight * scale;
    return ([DrawingConstants topBarHeight] + (mainScreenHeight - [DrawingConstants topBarHeight] - actualHeight) / 2) - (mainScreenHeight - actualHeight) / 2;
}

@end
