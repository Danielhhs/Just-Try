//
//  ColorSelectionManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/28/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ColorSelectionManager.h"
#import "ColorPickerViewController.h"

@interface ColorSelectionManager ()
@property (nonatomic, strong) UIPopoverController *colorPickerPopover;
@property (nonatomic, strong) ColorPickerViewController *colorPickerController;
@property (nonatomic) ColorUsageType usage;
@end

static ColorSelectionManager *sharedInstance;

@implementation ColorSelectionManager
#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.colorPickerController = [[UIStoryboard storyboardWithName:@"EditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"ColorPickerViewController"];
        self.colorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.colorPickerController];
//        self.colorPickerPopover.popoverContentSize = self.colorPickerController.view.bounds.size;
    }
    return self;
}

+ (ColorSelectionManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[ColorSelectionManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Show/Hide
- (void) showColorPickerFromRect:(CGRect)rect inView:(UIView *) view forType:(ColorUsageType)type
{
    self.colorPickerPopover.popoverContentSize = CGSizeMake(500, 500);
    [self.colorPickerPopover presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) hideColorPicker
{
    [self.colorPickerPopover dismissPopoverAnimated:YES];
}

- (UIColor *) selectedColorForType:(ColorUsageType)usage
{
    return [UIColor whiteColor];
}

@end
