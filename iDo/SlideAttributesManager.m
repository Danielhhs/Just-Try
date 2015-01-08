//
//  SlideAttributesManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "SlideAttributesManager.h"
#import "KeyConstants.h"
#import "UIView+Snapshot.h"
#import "Enums.h"
#import "ImageContent+iDo.h"
#import "TextContent+iDo.h"
#import "AnimationOrderDTO.h"
static SlideAttributesManager *sharedInstance = nil;

@interface SlideAttributesManager ()
@property (nonatomic, strong) SlideDTO *slideAttributes;
@property (nonatomic, strong) NSMutableArray *animations;
@end

@implementation SlideAttributesManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.animations = [NSMutableArray array];
    }
    return self;
}

+ (SlideAttributesManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[SlideAttributesManager alloc] initInternal];
    }
    return sharedInstance;
}

- (void) setSlideAttributes:(SlideDTO *)slideAttributes
{
    _slideAttributes = slideAttributes;
    [self.animations removeAllObjects];
    NSMutableArray *contents = slideAttributes.contents;
    for (GenericContentDTO *content in contents) {
        NSArray *contentAnimations = content.animations;
        if (contentAnimations != nil && [contentAnimations count] != 0) {
//            [self updateDescriptionForAnimations:contentAnimations inContent:content];
            [self.animations addObjectsFromArray:contentAnimations];
        }
    }
    [self.animations sortUsingComparator:^NSComparisonResult(AnimationDTO *obj1, AnimationDTO *obj2) {
        NSInteger index1 = obj1.index;
        NSInteger index2 = obj2.index;
        return index1 > index2;
    }];
}

//- (void) updateDescriptionForAnimations:(NSArray *) contentAnimations inContent:(GenericContentDTO *)content
//{
//    for (AnimationOrderDTO *animation in contentAnimations) {
//        if (content.contentType == ContentViewTypeText) {
//            animation.viewType = ContentViewTypeText;
//            NSAttributedString *attrString = ((TextContentDTO *)content).attributedString;
//            animation.animationDescription = attrString.string;
//        } else {
//            animation.viewType = ContentViewTypeImage;
//            animation.imageName = ((ImageContentDTO *)content).imageName;
//            animation.animationDescription = [content.uuid UUIDString];
//        }
//    }
//}

#pragma mark - Public APIs
- (void) addNewContent:(GenericContentDTO *)content toSlide:(SlideDTO *)slide
{
    [slide.contents addObject:content];
}

- (void) saveCanvasContents:(CanvasView *)canvas toSlide:(SlideDTO *)slide
{
    slide.thumbnail = [canvas snapshot];
    NSMutableArray *newContents = [NSMutableArray array];
    for (UIView *view in canvas.subviews) {
        if ([view isKindOfClass:[GenericContainerView class]]) {
            GenericContainerView *content = (GenericContainerView *) view;
            [newContents addObject:[content attributes]];
        }
    }
    slide.contents = newContents;
}

- (void) removeAnimation:(AnimationDTO *)animation
{
    NSInteger index = [self.animations indexOfObject:animation];
    [self.animations removeObject:animation];
    GenericContentDTO *content = [self findContentByUUID:animation.contentUUID];
    NSMutableArray *contentAnimations = [content.animations mutableCopy];
    for (AnimationDTO *contentAnimation in contentAnimations) {
        if (contentAnimation.event == animation.event) {
            [contentAnimations removeObject:contentAnimation];
            content.animations = contentAnimations;
            break;
        }
    }
    for (NSInteger i = index; i < [self.animations count]; i++) {
        AnimationDTO *slideAnimation = self.animations[i];
        slideAnimation.index = slideAnimation.index - 1;
    }
}

- (void) addAnimation:(AnimationDTO *)animation
{
    [self.animations addObject:animation];
    [self.animations sortUsingComparator:^NSComparisonResult(AnimationDTO *obj1, AnimationDTO *obj2) {
        NSInteger index1 = obj1.index;
        NSInteger index2 = obj2.index;
        return index1 > index2;
    }];
    GenericContentDTO *content = [self findContentByUUID:animation.contentUUID];
    [content.animations addObject:animation];
}

- (GenericContentDTO *) findContentByUUID:(NSUUID *)uuid
{
    for (GenericContentDTO *content in self.slideAttributes.contents) {
        if ([content.uuid isEqual:uuid]) {
            return content;
        }
    }
    return nil;
}

- (void) updateSlideWithAnimationDescription:(AnimationDescription *) animationDescription
                                     content:(GenericContainerView *)content
{
    AnimationDTO *editedAnimation = nil;
    for (AnimationDTO *animation in self.animations) {
        if ([animation.contentUUID isEqual:content.attributes.uuid] && animation.event == animationDescription.animationEvent) {
            editedAnimation = animation;
            break;
        }
    }
    if (editedAnimation == nil && animationDescription.animationEffect != AnimationEffectNone) {
        editedAnimation = [[AnimationDTO alloc] init];
        editedAnimation.contentUUID = content.attributes.uuid;
        editedAnimation.event = animationDescription.animationEvent;
        editedAnimation.index = [self.animations count] + 1;
        [self.animations addObject:editedAnimation];
        [self.animations sortUsingComparator:^NSComparisonResult(AnimationDTO *obj1, AnimationDTO *obj2) {
            NSInteger index1 = obj1.index;
            NSInteger index2 = obj2.index;
            return index1 > index2;
        }];
        
        GenericContentDTO *content = [self findContentByUUID:editedAnimation.contentUUID];
        [content.animations addObject:editedAnimation];
    }
    if (animationDescription.animationEffect == AnimationEffectNone) {
        [self removeAnimation:editedAnimation];
    } else {
        editedAnimation.effect = animationDescription.animationEffect;
        editedAnimation.duration = animationDescription.parameters.duration;
        editedAnimation.triggeredTime = animationDescription.parameters.timeAfterPreviousAnimation;
        editedAnimation.direction = animationDescription.parameters.selectedDirection;
    }
}

- (AnimationDTO *) findAnimationInContent:(AnimationDTO *) animation
{
    AnimationDTO *result;
    
    for (GenericContentDTO *content in self.slideAttributes.contents) {
        if ([content.uuid isEqual:animation.contentUUID]) {
            for (AnimationDTO *contentAnimation in content.animations) {
                if (animation.event == contentAnimation.event) {
                    return contentAnimation;
                }
            }
        }
    }
    
    return result;
}

- (NSInteger) currentAnimationIndex
{
    return [self.animations count];
}

- (GenericConent *) genericContentFromAttributes:(GenericContentDTO *)attribtues inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    ContentViewType type = attribtues.contentType;
    GenericConent *content = nil;
    switch (type) {
        case ContentViewTypeImage:
            content = [ImageContent imageContentFromAttribute:(ImageContentDTO *)attribtues inManageObjectContext:managedObjectContext];
            break;
        case ContentViewTypeText:
            content = [TextContent textContentFromAttribute:(TextContentDTO *)attribtues inManageObjectContext:managedObjectContext];
        default:
            break;
    }
    return content;
}

- (NSArray *) currentSlideAnimationDescriptions
{
    NSMutableArray *animationOrderDescriptions = [NSMutableArray array];
    for (AnimationDTO *animation in self.animations) {
        AnimationOrderDTO *animationOrder = [[AnimationOrderDTO alloc] init];
        animationOrder.index = animation.index;
        animationOrder.event = animation.event;
        GenericContentDTO *content = [self findContentByUUID:animation.contentUUID];
        ContentViewType contentType = content.contentType;
        animationOrder.viewType = contentType;
        if (contentType == ContentViewTypeImage) {
            animationOrder.imageName = ((ImageContentDTO *)content).imageName;
            animationOrder.animationDescription = [content.uuid UUIDString];
        } else if (contentType == ContentViewTypeText) {
            animationOrder.animationDescription = ((TextContentDTO *)content).attributedString.string;
        }
        [animationOrderDescriptions addObject:animationOrder];
    }
    return animationOrderDescriptions;
}

- (void) switchAnimationAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    AnimationDTO *selectedAnimation = self.animations[fromIndex];
    [self.animations removeObject:selectedAnimation];
    [self.animations insertObject:selectedAnimation atIndex:toIndex];
    selectedAnimation.index = toIndex + 1;
    if (fromIndex > toIndex) {
        for (NSInteger i = toIndex + 1; i <= fromIndex; i++) {
            AnimationDTO *animation = self.animations[i];
            animation.index += 1;
        }
    } else {
        for (NSInteger i = fromIndex; i < toIndex; i++) {
            AnimationDTO *animation = self.animations[i];
            animation.index -= 1;
        }
    }
}

@end
