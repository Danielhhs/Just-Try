//
//  SlideAttributesManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanvasView.h"
#import "GenericConent.h"
#import "AnimationDescription.h"

#import "GenericContainerView.h"
#import "AnimationDescription.h"

@interface SlideAttributesManager : NSObject

+ (SlideAttributesManager *) sharedManager;

- (void) setSlideAttributes:(NSMutableDictionary *) slideAttributes;

- (void) addNewContent:(NSMutableDictionary *) content toSlide:(NSMutableDictionary *) slide;

- (void) saveCanvasContents:(CanvasView *)canvas toSlide:(NSMutableDictionary *) slide;

- (GenericConent *) genericContentFromAttributes:(NSDictionary *) attribtues inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

- (NSInteger) currentAnimationIndex;

- (NSArray *) currentSlideAnimations;

- (void) removeAnimation:(NSMutableDictionary *)animation;

- (void) updateSlideWithAnimationDescription:(AnimationDescription *) animationDescription
                                     content:(GenericContainerView *)content;

- (void) switchAnimationAtIndex:(NSInteger) fromIndex toIndex:(NSInteger) toIndex;
@end
