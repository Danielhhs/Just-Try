//
//  SlidesContainerViewController.h
//  iDo
//
//  Created by Huang Hongsen on 11/10/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidesEditingViewController.h"
#import "ProposalDTO.h"

@interface SlidesContainerViewController : UIViewController

- (void) adjustCanvasSizeAndPosition;

@property (nonatomic, strong) ProposalDTO *proposalAttributes;
@property (nonatomic, strong) SlidesEditingViewController *editorViewController;

@end
