//
//  SlidesPlayViewController.h
//  iDo
//
//  Created by Huang Hongsen on 1/25/16.
//  Copyright © 2016 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposalDTO.h"
@interface SlidesPlayViewController : UIViewController

@property (nonatomic, strong) ProposalDTO *proposal;

- (void) startPlaying;
- (CGRect) canvasFrame;
- (UIImage *) canvasSnapshot;

@end
