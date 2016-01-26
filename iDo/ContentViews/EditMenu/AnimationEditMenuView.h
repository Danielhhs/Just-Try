//
//  AnimationEditMenuView.h
//  iDo
//
//  Created by Huang Hongsen on 12/30/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "EditMenuView.h"
#import "AnimationConstants.h"
@class GenericContainerView;
@interface AnimationEditMenuView : EditMenuView
- (void) updateEditAnimationItemWithAnimationName:(NSString *) animationName animationOrder:(NSInteger) animationOrder forContent:(GenericContainerView *)content;
- (void) showToContent:(GenericContainerView *) content animated:(BOOL) animated;
@end
