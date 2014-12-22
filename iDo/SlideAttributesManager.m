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
#import "GenericContentConstants.h"
#import "ImageContent+iDo.h"
#import "TextContent+iDo.h"
static SlideAttributesManager *sharedInstance = nil;

@interface SlideAttributesManager ()
@property (nonatomic, strong) NSMutableDictionary *slideAttributes;
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

- (void) setSlideAttributes:(NSMutableDictionary *)slideAttributes
{
    _slideAttributes = slideAttributes;
    [self.animations removeAllObjects];
    NSMutableArray *contents = slideAttributes[[KeyConstants slideContentsKey]];
    for (NSMutableDictionary *content in contents) {
        NSArray *contentAnimations = content[[KeyConstants animationsKey]];
        if (contentAnimations != nil && [contentAnimations count] != 0) {
            [self.animations addObjectsFromArray:contentAnimations];
        }
    }
    [self.animations sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSInteger index1 = [obj1[[KeyConstants animationIndexKey]] integerValue];
        NSInteger index2 = [obj2[[KeyConstants animationIndexKey]] integerValue];
        return index1 > index2;
    }];
}

#pragma mark - Public APIs
- (void) addNewContent:(NSMutableDictionary *)content toSlide:(NSMutableDictionary *)slide
{
    NSMutableArray *contents = slide[[KeyConstants slideContentsKey]];
    [contents addObject:content];
    [slide setValue:contents forKey:[KeyConstants slideContentsKey]];
}

- (void) saveCanvasContents:(CanvasView *)canvas toSlide:(NSMutableDictionary *)slide
{
    [slide setValue:[canvas snapshot] forKey:[KeyConstants slideThumbnailKey]];
    NSMutableArray *newContents = [NSMutableArray array];
    for (UIView *view in canvas.subviews) {
        if ([view isKindOfClass:[GenericContainerView class]]) {
            GenericContainerView *content = (GenericContainerView *) view;
            [newContents addObject:[content attributes]];
        }
    }
    [slide setValue:newContents forKey:[KeyConstants slideContentsKey]];
}

- (void) removeAnimation:(NSMutableDictionary *)animation
{
    NSInteger index = [self.animations indexOfObject:animation];
    [self.animations removeObject:animation];
    for (NSInteger i = index; i < [self.animations count]; i++) {
        NSMutableDictionary *slideAnimation = self.animations[i];
        slideAnimation[[KeyConstants animationIndexKey]] = @([slideAnimation[[KeyConstants animationIndexKey]] integerValue] - 1);
        NSMutableDictionary *animationInContent = [self findAnimationInContent:slideAnimation];
        NSInteger animationIndex = [animationInContent[[KeyConstants animationIndexKey]] integerValue] - 1;
        [animationInContent setValue:@(animationIndex) forKey:[KeyConstants animationIndexKey]];
    }
}

- (void) updateSlideWithAnimationDescription:(AnimationDescription *) animationDescription
                                     content:(GenericContainerView *)content
{
    NSMutableDictionary *editedAnimation = nil;
    for (NSMutableDictionary *animation in self.animations) {
        if ([animation[[KeyConstants contentUUIDKey]] isEqual:[content attributes][[KeyConstants contentUUIDKey]]] && [animation[[KeyConstants animationEventKey]] integerValue] == animationDescription.animationEvent ) {
            editedAnimation = animation;
            break;
        }
    }
    if (editedAnimation == nil && animationDescription.animationEffect != AnimationEffectNone) {
        editedAnimation = [NSMutableDictionary dictionary];
        editedAnimation[[KeyConstants contentUUIDKey]] = [content attributes][[KeyConstants contentUUIDKey]];
        editedAnimation[[KeyConstants animationEventKey]] = @(animationDescription.animationEvent);
        editedAnimation[[KeyConstants animationIndexKey]] = @([self.animations count] + 1);
        [self.animations addObject:editedAnimation];
        [self.animations sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSInteger index1 = [obj1[[KeyConstants animationIndexKey]] integerValue];
            NSInteger index2 = [obj2[[KeyConstants animationIndexKey]] integerValue];
            return index1 > index2;
        }];
    }
    if (animationDescription.animationEffect == AnimationEffectNone) {
        [self removeAnimation:editedAnimation];
    } else {
        editedAnimation[[KeyConstants animationEffectKey]] = @(animationDescription.animationEffect);
        editedAnimation[[KeyConstants animationDurationKey]] = @(animationDescription.parameters.duration);
        editedAnimation[[KeyConstants animationTriggerTimeKey]] = @(animationDescription.parameters.timeAfterPreviousAnimation);
        editedAnimation[[KeyConstants animationDirectionKey]] = @(animationDescription.parameters.selectedDirection);
    }
}

- (NSMutableDictionary *) findAnimationInContent:(NSMutableDictionary *) animation
{
    NSMutableDictionary *result;
    
    NSMutableArray *contents = self.slideAttributes[[KeyConstants slideContentsKey]];
    for (NSMutableDictionary *content in contents) {
        if ([content[[KeyConstants contentUUIDKey]] isEqual:animation[[KeyConstants contentUUIDKey]]]) {
            NSMutableArray *animations = content[[KeyConstants animationsKey]];
            for (NSMutableDictionary *contentAnimation in animations) {
                if ([animation[[KeyConstants animationEventKey]] isEqualToNumber:contentAnimation[[KeyConstants animationEventKey]]]) {
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

- (GenericConent *) genericContentFromAttributes:(NSDictionary *)attribtues inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    ContentViewType type = [attribtues[[KeyConstants contentTypeKey]] integerValue];
    GenericConent *content = nil;
    switch (type) {
        case ContentViewTypeImage:
            content = [ImageContent imageContentFromAttribute:attribtues inManageObjectContext:managedObjectContext];
            break;
        case ContentViewTypeText:
            content = [TextContent textContentFromAttribute:attribtues inManageObjectContext:managedObjectContext];
        default:
            break;
    }
    return content;
}

- (NSArray *) currentSlideAnimations
{
    return [self.animations copy];
}

@end
