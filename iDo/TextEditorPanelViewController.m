//
//  TextEditorPanelViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextEditorPanelViewController.h"
#import "GenericContainerViewHelper.h"
#import "TextFontHelper.h"

#define PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX 0
#define PICK_VIEW_FONT_NAME_COMPONENT_INDEX 1
#define PICK_VIEW_SIZE_COMPONENT_INDEX 2

#define PICK_VIEW_FONT_SIZE 12

#define PICK_VIEW_FONT_FAMILY_RATIO 0.6
#define PICK_VIEW_FONT_NAME_RATIO 0.3
#define PICK_VIEW_FONT_SIZE_RATIO 0.1

#define KEYBOARD_OFFSET 200


@interface TextEditorPanelViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (nonatomic, strong) NSArray *fontFamilies;
@property (nonatomic, strong) NSArray *displayingFontNames;
@property (nonatomic, strong) NSArray *fullFontNames;
@property (nonatomic, strong) NSArray *fontSizes;
@property (nonatomic) TextAlignment alignment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentSegment;

@end

@implementation TextEditorPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Event Handling

- (IBAction)handleTap:(id)sender {
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
        return [self.fontFamilies count];
    } else if ([self componentIsFontNameSelector:component]) {
        NSInteger currentFontFamilyComponent = [pickerView selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
        return [self.displayingFontNames[currentFontFamilyComponent] count];
    } else if (component == PICK_VIEW_SIZE_COMPONENT_INDEX) {
        return [self.fontSizes count];
    }
    return 0;
}

- (NSArray *) fontFamilies
{
    if (!_fontFamilies) {
        _fontFamilies = [TextFontHelper allFontFamilies];
    }
    return _fontFamilies;
}

- (NSArray *) fontSizes
{
    if (!_fontSizes) {
        _fontSizes = [TextFontHelper allSizes];
    }
    return _fontSizes;
}

- (NSArray *) displayingFontNames
{
    if (!_displayingFontNames) {
        _displayingFontNames = [TextFontHelper displayingFontNamesForEachFontFamilies];
    }
    return _displayingFontNames;
}

- (NSArray *) fullFontNames{
    if (!_fullFontNames) {
        _fullFontNames = [TextFontHelper fullFontNames];
    }
    return _fullFontNames;
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
        NSString *fontFamily = self.fontFamilies[row];
        UIFont *font = [UIFont fontWithName:fontFamily size:PICK_VIEW_FONT_SIZE];
        attributedTitle = [[NSAttributedString alloc] initWithString:fontFamily attributes:@{NSFontAttributeName : font}];
    } else if ([self componentIsFontNameSelector:component]) {
        NSInteger fontFamilyRow = [pickerView selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
        NSString *displayingFontName = self.displayingFontNames[fontFamilyRow][row];
        NSString *fullFontName = self.fullFontNames[fontFamilyRow][row];
        UIFont *font = [UIFont fontWithName:fullFontName size:PICK_VIEW_FONT_SIZE];
        attributedTitle = [[NSAttributedString alloc] initWithString:displayingFontName attributes:@{NSFontAttributeName : font}];
    } else {
        UIFont *font = [UIFont systemFontOfSize:PICK_VIEW_FONT_SIZE];
        NSString *fontSize = [NSString stringWithFormat:@"%d", [self.fontSizes[row] intValue]];
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
    [pickerView reloadComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
    [self.delegate textAttributes:@{[GenericContainerViewHelper fontKey] : [self fontFromCurrentSelection]} didChangeFromTextEditor:self];
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
    CGFloat fontSize = [self.fontSizes[[self.fontPicker selectedRowInComponent:PICK_VIEW_SIZE_COMPONENT_INDEX]] doubleValue];
    NSInteger fontFamilyRow = [self.fontPicker selectedRowInComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX];
    NSInteger fontNameRow = [self.fontPicker selectedRowInComponent:PICK_VIEW_FONT_NAME_COMPONENT_INDEX];
    NSString *fullFontName = self.fullFontNames[fontFamilyRow][fontNameRow];
    UIFont *font = [UIFont fontWithName:fullFontName size:fontSize];
    return font;
}

#pragma mark - Text Alignment

- (IBAction)textAlignmentChanged:(UISegmentedControl *)sender {
    self.alignment = sender.selectedSegmentIndex;
    [self.delegate textAttributes:@{[GenericContainerViewHelper alignmentKey] : @(self.alignment)} didChangeFromTextEditor:self];
}

#pragma mark - KeyboardEvents
- (void) keyboardWillShow:(NSNotification *) notification
{
    self.view.frame = CGRectOffset(self.view.frame, 0, -1 * KEYBOARD_OFFSET);
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    self.view.frame = CGRectOffset(self.view.frame, 0, KEYBOARD_OFFSET);
}

#pragma mark - Apply Attributes
- (void) applyAttributes:(NSDictionary *)attributes
{
    [super applyAttributes:attributes];
    UIFont *font = [attributes objectForKey:[GenericContainerViewHelper fontKey]];
    if (font) {
        NSString *familyName = font.familyName;
        NSInteger index = [self.fontFamilies indexOfObject:familyName];
        [self.fontPicker selectRow:index inComponent:PICK_VIEW_FONT_FAMILY_NAME_COMPONENT_INDEX animated:NO];
        
        CGFloat size = font.pointSize;
        index = [self.fontSizes indexOfObject:@(size)];
        [self.fontPicker selectRow:index inComponent:PICK_VIEW_SIZE_COMPONENT_INDEX animated:YES];
    }
}

@end
