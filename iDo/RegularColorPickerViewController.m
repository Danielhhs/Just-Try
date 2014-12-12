//
//  RegularColorPickerViewController.m
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "RegularColorPickerViewController.h"
#import "RegularColorGenerator.h"
#import "RegularColorPickerCollectioinViewCell.h"
@interface RegularColorPickerViewController()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *colorsCollectionView;
@property (nonatomic, strong) NSArray *regularColors;
@property (nonatomic) NSInteger currentSelectedColorIndex;
@end
@implementation RegularColorPickerViewController

- (NSArray *) regularColors
{
    if (!_regularColors) {
        _regularColors = [RegularColorGenerator regularColors];
    }
    return _regularColors;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self deselectCurrentSelectedColor];
    self.currentSelectedColorIndex = -1;
}

#pragma mark - UICollectionViewDataSouce
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.regularColors count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegularColorCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RegularColorPickerCollectioinViewCell class]]) {
        RegularColorPickerCollectioinViewCell *colorCell = (RegularColorPickerCollectioinViewCell *)cell;
        colorCell.color = [self.regularColors objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - User Interaction
- (void) setCurrentSelectedColorIndex:(NSInteger)currentSelectedColorIndex
{
    if (currentSelectedColorIndex == -1) {
        _currentSelectedColorIndex = currentSelectedColorIndex;
        return;
    }
    if (_currentSelectedColorIndex != currentSelectedColorIndex) {
        [self deselectCurrentSelectedColor];
        _currentSelectedColorIndex = currentSelectedColorIndex;
        [self.delegate regularColorPickerViewController:self didSelectColor:self.regularColors[currentSelectedColorIndex]];
        RegularColorPickerCollectioinViewCell *cell = (RegularColorPickerCollectioinViewCell *) [self.colorsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentSelectedColorIndex inSection:0]];
        cell.selected = !cell.selected;
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.colorsCollectionView];
    NSIndexPath *indexPath = [self.colorsCollectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        self.currentSelectedColorIndex = indexPath.row;
    }
}

- (void) deselectCurrentSelectedColor
{
    UICollectionViewCell *cell = [self.colorsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectedColorIndex inSection:0]];
    cell.selected = NO;
}


- (void) setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.currentSelectedColorIndex = [self findSelectedColorIndexForColor:selectedColor];
}

- (NSInteger) findSelectedColorIndexForColor:(UIColor *)selectedColor
{
    NSInteger index = -1;
    for (NSInteger i = 0; i < [self.regularColors count]; i++) {
        UIColor *color = self.regularColors[i];
        if ([color isEqual:selectedColor]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
