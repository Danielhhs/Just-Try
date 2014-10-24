//
//  TextEditorPanelViewController.m
//  iDo
//
//  Created by Huang Hongsen on 10/20/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "TextEditorPanelViewController.h"
#import "GenericContainerViewHelper.h"

#define PICK_VIEW_FONT_COMPONENT_INDEX 0
#define PICK_VIEW_SIZE_COMPONENT_INDEX 1

#define PICK_VIEW_FONT_SIZE 8

#define MIN_FONT_SIZE 2
#define MAX_FONT_SIEZ 60

@interface TextEditorPanelViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (nonatomic, strong) NSMutableArray *allFonts;
@property (nonatomic, strong) NSMutableArray *allSizes;

@property (nonatomic) BOOL bold;
@property (nonatomic) BOOL italic;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic) NSUInteger size;
@property (nonatomic) TextAlignment alignment;
@property (weak, nonatomic) IBOutlet UIButton *boldButton;
@property (weak, nonatomic) IBOutlet UIButton *italicButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alignmentSegment;

@end

@implementation TextEditorPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Event Handling
- (IBAction)boldPressed {
    self.bold = !self.bold;
    [self.delegate textAttributes:@{[GenericContainerViewHelper boldKey] : @(self.bold)} didChangeFromTextEditor:self];
}


- (IBAction)ItalicPressed {
    self.italic = !self.italic;
    [self.delegate textAttributes:@{[GenericContainerViewHelper italicKey] : @(self.italic)} didChangeFromTextEditor:self];
}

- (IBAction)textAlignmentChanged:(UISegmentedControl *)sender {
    self.alignment = sender.selectedSegmentIndex;
    [self.delegate textAttributes:@{[GenericContainerViewHelper alignmentKey] : @(self.alignment)} didChangeFromTextEditor:self];
}

- (IBAction)handleTap:(id)sender {
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    if (component == PICK_VIEW_FONT_COMPONENT_INDEX) {
        return [self.allFonts count];
    } else if (component == PICK_VIEW_SIZE_COMPONENT_INDEX) {
        return [self.allSizes count];
    }
    return 0;
}

- (NSMutableArray *) allFonts
{
    if (!_allFonts) {
        _allFonts = [NSMutableArray array];
        for (NSString *familyName in [UIFont familyNames]) {
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                [_allFonts addObject:fontName];
            }
        }
    }
    return _allFonts;
}

- (NSMutableArray *) allSizes
{
    if (!_allSizes) {
        _allSizes = [NSMutableArray array];
        for (int i = MIN_FONT_SIZE; i <= MAX_FONT_SIEZ; i += 2) {
            [_allSizes addObject:@(i)];
        }
    }
    return _allSizes;
}

#pragma mark - UIPickerViewDelegate
- (NSAttributedString *) pickerView:(UIPickerView *)pickerView
              attributedTitleForRow:(NSInteger)row
                       forComponent:(NSInteger)component
{
    NSAttributedString *attributedTitle = nil;
    if (component == PICK_VIEW_FONT_COMPONENT_INDEX) {
        NSString *fontName = self.allFonts[row];
        UIFont *font = [UIFont fontWithName:fontName size:PICK_VIEW_FONT_SIZE];
        attributedTitle = [[NSAttributedString alloc] initWithString:fontName attributes:@{NSFontAttributeName : font}];
    } else {
        UIFont *font = [UIFont systemFontOfSize:PICK_VIEW_FONT_SIZE];
        NSString *fontSize = [NSString stringWithFormat:@"%d", [self.allSizes[row] intValue]];
        attributedTitle = [[NSAttributedString alloc] initWithString:fontSize attributes:@{NSFontAttributeName : font}];
    }
    
    return attributedTitle;
}

- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    if (component == PICK_VIEW_FONT_COMPONENT_INDEX) {
        self.fontName = self.allFonts[row];
        [self.delegate textAttributes:@{[GenericContainerViewHelper fontKey] : self.fontName} didChangeFromTextEditor:self];
    } else  if (component == PICK_VIEW_SIZE_COMPONENT_INDEX) {
        self.size = [self.allSizes[row] intValue];
        [self.delegate textAttributes:@{[GenericContainerViewHelper sizeKey] : @(self.size)} didChangeFromTextEditor:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
