//
//  TextEditorPanelViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextBasicEditorPanelViewController.h"
#import "GenericContainerViewHelper.h"
#import "TextFontHelper.h"
#import "KeyConstants.h"
#import "UndoManager.h"
#import "SimpleOperation.h"
#import "CompoundOperation.h"
#import "ColorSelectionManager.h"
#import "ColorPickerViewController.h"

#define PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX 0
#define PICK_VIEW_FONT_NAME_COMPONENT_INDEX 1
#define PICK_VIEW_SIZE_COMPONENT_INDEX 2
#define PICK_VIEW_FONT_SIZE 12
#define PICK_VIEW_FONT_FAMILY_RATIO 0.6
#define PICK_VIEW_FONT_NAME_RATIO 0.3
#define PICK_VIEW_FONT_SIZE_RATIO 0.1

@interface TextBasicEditorPanelViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, OperationTarget, ColorPickerContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (nonatomic) TextAlignment alignment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentSegment;
@property (nonatomic, strong) UIFont *lastSelectedFont;
@property (nonatomic, strong) UIColor *lastSelectedTextColor;
@property (nonatomic, strong) UIColor *lastSelectedBackgroundColor;
@property (nonatomic) NSRange selectedRange;
@property (weak, nonatomic) IBOutlet UIButton *textColorButton;
@property (weak, nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (nonatomic) ColorUsageType colorUsage;
@end

@implementation TextBasicEditorPanelViewController
#pragma mark - Event Handling
- (IBAction)handleTap:(id)sender {
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ColorSelectionManager sharedManager] setColorPickerDelegate:self];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    if ([self componentIsFontFamilySelector:component]) {
        return [[TextFontHelper allFontFamilies] count];
    } else if ([self componentIsFontNameSelector:component]) {
        NSInteger currentFontFamilyComponent = [pickerView selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
        return [[TextFontHelper displayingFontNamesForEachFontFamilies][currentFontFamilyComponent] count];
    } else if (component == PICK_VIEW_SIZE_COMPONENT_INDEX) {
        return [[TextFontHelper allSizes] count];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (UIView *) pickerView:(UIPickerView *)pickerView
             viewForRow:(NSInteger)row
           forComponent:(NSInteger)component
            reusingView:(UIView *)view
{
    UILabel *label;
    if ([view isKindOfClass:[UILabel class]]) {
        label = (UILabel *) view;
    } else {
        label = [[UILabel alloc] init];
    }
    NSAttributedString *attributedTitle = nil;
    if ([self componentIsFontFamilySelector:component]) {
        NSString *fontFamily = [TextFontHelper allFontFamilies][row];
        UIFont *font = [UIFont fontWithName:fontFamily size:PICK_VIEW_FONT_SIZE];
        attributedTitle = [[NSAttributedString alloc] initWithString:fontFamily attributes:@{NSFontAttributeName : font}];
    } else if ([self componentIsFontNameSelector:component]) {
        NSInteger fontFamilyRow = [pickerView selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
        NSString *displayingFontName = [TextFontHelper displayingFontNamesForEachFontFamilies][fontFamilyRow][row];
        NSString *fullFontName = [TextFontHelper fullFontNames][fontFamilyRow][row];
        UIFont *font = [UIFont fontWithName:fullFontName size:PICK_VIEW_FONT_SIZE];
        attributedTitle = [[NSAttributedString alloc] initWithString:displayingFontName attributes:@{NSFontAttributeName : font}];
    } else {
        UIFont *font = [UIFont systemFontOfSize:PICK_VIEW_FONT_SIZE];
        NSString *fontSize = [NSString stringWithFormat:@"%d", [[TextFontHelper allSizes][row] intValue]];
        attributedTitle = [[NSAttributedString alloc] initWithString:fontSize attributes:@{NSFontAttributeName : font}];
    }
    label.attributedText = attributedTitle;
    return label;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView
     widthForComponent:(NSInteger)component
{
    if ([self componentIsFontFamilySelector:component]) {
        return pickerView.bounds.size.width * PICK_VIEW_FONT_FAMILY_RATIO;
    } else if ([self componentIsFontNameSelector:component]) {
        return pickerView.bounds.size.width * PICK_VIEW_FONT_NAME_RATIO;
    } else {
        return pickerView.bounds.size.width * PICK_VIEW_FONT_SIZE_RATIO;
    }
}

- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    if ([self componentIsFontFamilySelector:component]) {
        [pickerView reloadComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
    }
    UIFont *selectedFont = [self fontFromCurrentSelection];
    [self applyFontAttributeValue:selectedFont forName:NSFontAttributeName attributeKey:[KeyConstants fontKey] pushUndoOperation:YES];
    self.lastSelectedFont = selectedFont;
}

- (void) applyFontAttributeValue:(NSObject *) attributeValue
                         forName:(NSString *) attributeName
                    attributeKey:(NSString *) attributeKey
               pushUndoOperation:(BOOL) pushOperation
{
    NSAttributedString *originalText = [self.attributes objectForKey:[KeyConstants attibutedStringKey]];
    NSMutableAttributedString *attributedString = [originalText mutableCopy];
    SimpleOperation *textOperation = [[SimpleOperation alloc] initWithTargets:@[self.target] key:[KeyConstants attibutedStringKey] fromValue:originalText];
    [attributedString enumerateAttribute:attributeName inRange:self.selectedRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        [attributedString addAttribute:attributeName value:attributeValue range:range];
    }];
    [self.delegate textAttributes:@{[KeyConstants attibutedStringKey] : attributedString, [KeyConstants textSelectionKey] : [NSValue valueWithRange:self.selectedRange]} didChangeFromTextEditor:self];
    if (pushOperation) {
        SimpleOperation *fontOperation = [[SimpleOperation alloc] initWithTargets:@[self] key:attributeKey fromValue:self.lastSelectedFont];
        fontOperation.toValue = attributeValue;
        NSValue *textSelectionValue = [NSValue valueWithRange:self.selectedRange];
        SimpleOperation *selectionOperation = [[SimpleOperation alloc] initWithTargets:@[self.target, self] key:[KeyConstants textSelectionKey] fromValue:textSelectionValue];
        selectionOperation.toValue = textSelectionValue;
        textOperation.toValue = attributedString;
        CompoundOperation *compoundOperation = [[CompoundOperation alloc] initWithOperations:@[selectionOperation, textOperation, fontOperation]];
        [[UndoManager sharedManager] pushOperation:compoundOperation];
    }
}

- (BOOL) componentIsFontFamilySelector:(NSInteger) component
{
    return component == PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX;
}

- (BOOL) componentIsFontNameSelector:(NSInteger) component
{
    return component == PICK_VIEW_FONT_NAME_COMPONENT_INDEX;
}

- (BOOL) componentIsFontSizeSelector:(NSInteger) component
{
    return component == PICK_VIEW_SIZE_COMPONENT_INDEX;
}

- (UIFont *) fontFromCurrentSelection
{
    CGFloat fontSize = [[TextFontHelper allSizes][[self.fontPicker selectedRowInComponent:PICK_VIEW_SIZE_COMPONENT_INDEX]] doubleValue];
    NSInteger fontFamilyRow = [self.fontPicker selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
    NSInteger fontNameRow = [self.fontPicker selectedRowInComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
    NSString *fullFontName = [TextFontHelper fullFontNames][fontFamilyRow][fontNameRow];
    UIFont *font = [UIFont fontWithName:fullFontName size:fontSize];
    return font;
}

#pragma mark - Text Alignment

- (IBAction)textAlignmentChanged:(UISegmentedControl *)sender {
    SimpleOperation *operation = [[SimpleOperation alloc] initWithTargets:@[self.target, self] key:[KeyConstants alignmentKey] fromValue:@(self.alignment)];
    self.alignment = sender.selectedSegmentIndex;
    operation.toValue = @(self.alignment);
    [[UndoManager sharedManager] pushOperation:operation];
    [self.delegate textAttributes:@{[KeyConstants alignmentKey] : @(self.alignment)} didChangeFromTextEditor:self];
}

#pragma mark - Apply Attributes

- (void) applyUndoRedoAttributes:(NSDictionary *)attributes
{
    UIFont *font = [attributes objectForKey:[KeyConstants fontKey]];
    if (font) {
        NSString *familyName = font.familyName;
        NSInteger index = [[TextFontHelper allFontFamilies] indexOfObject:familyName];
        [self.fontPicker selectRow:index inComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX animated:NO];
        [self.fontPicker reloadComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
        
        NSString *fontName = font.fontName;
        index = [[TextFontHelper displayingFontNamesForEachFontFamilies][index] indexOfObject:[TextFontHelper displayingFontNameFromFamilyName:familyName fontName:fontName]];
        [self.fontPicker selectRow:index inComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX animated:NO];
        
        CGFloat size = font.pointSize;
        index = [[TextFontHelper allSizes] indexOfObject:@(size)];
        [self.fontPicker selectRow:index inComponent:PICK_VIEW_SIZE_COMPONENT_INDEX animated:YES];
        self.lastSelectedFont = font;
    }
    NSNumber *alignment = [attributes objectForKey:[KeyConstants alignmentKey]];
    if (alignment) {
        self.alignmentSegment.selectedSegmentIndex = [alignment integerValue];
    }
    NSValue *textSelection = [attributes objectForKey:[KeyConstants textSelectionKey]];
    if (textSelection) {
        self.selectedRange = [textSelection rangeValue];
    }
    UIColor *backgroundColor = [attributes objectForKey:[KeyConstants textBackgroundColorKey]];
    self.lastSelectedBackgroundColor = backgroundColor;
}

- (void) updateFontPickerByRange:(NSRange)range
{
    self.selectedRange = range;
    self.fontPicker.userInteractionEnabled = (range.length == 0) ? NO : YES;
}

- (void) selectFont:(UIFont *)font
{
    NSString *familyName = font.familyName;
    NSInteger index = [[TextFontHelper allFontFamilies] indexOfObject:familyName];
    [self.fontPicker selectRow:index inComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX animated:NO];
    [self.fontPicker reloadComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
    
    NSString *fontName = font.fontName;
    index = [[TextFontHelper displayingFontNamesForEachFontFamilies][index] indexOfObject:[TextFontHelper displayingFontNameFromFamilyName:familyName fontName:fontName]];
    [self.fontPicker selectRow:index inComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX animated:NO];
    
    CGFloat size = font.pointSize;
    index = [[TextFontHelper allSizes] indexOfObject:@(size)];
    [self.fontPicker selectRow:index inComponent:PICK_VIEW_SIZE_COMPONENT_INDEX animated:YES];
    self.lastSelectedFont = font;
}

- (IBAction)showTextColorPicker:(UIButton *)sender {
    UIColor *currentColor = [sender.currentTitle isEqualToString:@"Text Color"] ? self.lastSelectedTextColor : self.lastSelectedBackgroundColor;
    [self.delegate showColorPickerForColor:currentColor];
    self.colorUsage = [sender.currentTitle isEqualToString:@"Text Color"] ? ColorUsageTypeTextColor : ColorUsageTypeTextBackground;
}

#pragma mark - Operation Target
- (void) performOperation:(SimpleOperation *)operation
{
    [self applyUndoRedoAttributes:@{operation.key : operation.toValue}];
}

#pragma mark - ColorPickerViewControllerDelegate
- (void) colorPickerDidSelectColor:(UIColor *)color
{
    if (self.colorUsage == ColorUsageTypeTextColor) {
        [self applyFontAttributeValue:color forName:NSForegroundColorAttributeName attributeKey:[KeyConstants textColorKey] pushUndoOperation:YES];
    } else {
        SimpleOperation *backgroundOperation = [[SimpleOperation alloc] initWithTargets:@[self.target] key:[KeyConstants textBackgroundColorKey] fromValue:self.lastSelectedBackgroundColor];
        backgroundOperation.toValue = color;
        [[UndoManager sharedManager] pushOperation:backgroundOperation];
        self.lastSelectedBackgroundColor = color;
        [self.delegate textAttributes:@{[KeyConstants textBackgroundColorKey] : color} didChangeFromTextEditor:self];
    }
}

- (void) colorPickerDidChangeToColor:(UIColor *)color
{
    if (self.colorUsage == ColorUsageTypeTextColor) {
        [self applyFontAttributeValue:color forName:NSForegroundColorAttributeName attributeKey:[KeyConstants textColorKey] pushUndoOperation:NO];
    } else {
        [self.delegate changeTextContainerBackgroundColor:color];
    }
}

@end
