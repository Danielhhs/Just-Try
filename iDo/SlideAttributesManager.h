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
#import "GenericContentDTO.h"
#import "SlideDTO.h"
#import "AnimationDTO.h"
@interface SlideAttributesManager : NSObject

+ (SlideAttributesManager *) sharedManager;

- (void) setSlideAttributes:(SlideDTO *) slideAttributes;

- (void) addNewContent:(GenericContentDTO *) content toSlide:(SlideDTO *) slide;

- (void) saveCanvasContents:(CanvasView *)canvas toSlide:(SlideDTO *) slide;

- (GenericConent *) genericContentFromAttributes:(GenericContentDTO *) attribtues inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

- (NSInteger) currentAnimationIndex;

- (NSArray *) currentSlideAnimationDescriptions;

- (void) removeAnimation:(AnimationDTO *)animation;
- (void) addAnimation:(AnimationDTO *)animation;

- (void) updateSlideWithAnimationDescription:(AnimationDescription *) animationDescription
                                     content:(GenericContainerView *)content;

- (void) switchAnimationAtIndex:(NSInteger) fromIndex toIndex:(NSInteger) toIndex;
@end
