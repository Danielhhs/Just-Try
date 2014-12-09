//
//  AnimationToolbarViewController.h
//  iDo
//
//  Created by Huang Hongsen on 12/9/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnimationToolbarViewControllerDelegate
- (void) exitAnimationMode;
- (void) playAnimationForCurrentSelectedView;
@end

@interface AnimationToolbarViewController : UIViewController
@property (nonatomic, weak) id<AnimationToolbarViewControllerDelegate> delegate;
@end
