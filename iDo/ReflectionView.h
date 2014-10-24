//
//  ReflectionView.h
//  iDo
//
//  Created by Huang Hongsen on 10/23/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericContainerView.h"

@interface ReflectionView : UIView

- (instancetype) initWithOriginalView:(GenericContainerView *) originalView;

- (void) updateFrame;

@property (nonatomic, strong) GenericContainerView *originalView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat height;

@end
