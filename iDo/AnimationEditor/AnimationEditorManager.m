//
//  AnimationEditorManager.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationEditorManager.h"
#import "GenericContainerView.h"
#import "CanvasView.h"
#import "KeyConstants.h"
#import "AnimationAttributesHelper.h"
@interface AnimationEditorManager()
@property (nonatomic, strong) UIPopoverController *animationEditorPopover;
@property (nonatomic, strong) AnimationEditorContainerViewController *animationEditorContainer;
@end

static AnimationEditorManager *sharedInstance;

@implementation AnimationEditorManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        self.animationEditorContainer = [[UIStoryboard storyboardWithName:@"AnimationEditorViewControllers" bundle:nil] instantiateViewControllerWithIdentifier:@"AnimationEditorContainerViewController"];
        self.animationEditorPopover = [[UIPopoverController alloc] initWithContentViewController:self.animationEditorContainer];
    }
    return self;
}

+ (AnimationEditorManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[AnimationEditorManager alloc] initInternal];
    }
    return sharedInstance;
}

- (void) setAnimationEditorDelegate:(id<AnimationEditorContainerViewControllerDelegate>)delegate
{
    self.animationEditorContainer.delegate = delegate;
}

#pragma mark - Show & Hide
- (void) showAnimationEditorFromRect:(CGRect)rect
                              inView:(UIView *)view
                          forContent:(UIView *)content
                      animationEvent:(AnimationEvent)animationEvent
{
    self.animationEditorContainer.animationTarget = content;
    AnimationEffect animationEffect = [self findAnimationEffectFromView:content event:animationEvent];
    AnimationParameters *parameters = [self findAnimationParametersFromView:content event:animationEvent];
    self.animationEditorContainer.animation = [AnimationDescription animationDescriptionWithAnimationEffect:animationEffect animationEvent:animationEvent duration:parameters.duration permittedDirection:parameters.permittedDirection selectedDirection:parameters.selectedDirection  timeAfterLastAnimation:parameters.timeAfterPreviousAnimation];
    UIPopoverArrowDirection direction = UIPopoverArrowDirectionRight | UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    self.animationEditorPopover.popoverContentSize = CGSizeMake(250, 450);
    [self.animationEditorPopover presentPopoverFromRect:rect inView:view permittedArrowDirections:direction animated:YES];
}

- (AnimationEffect) findAnimationEffectFromView:(UIView *) view event:(AnimationEvent) event
{
    if ([view isKindOfClass:[GenericContainerView class]]) {
        GenericContainerView *content = (GenericContainerView *)view;
        NSArray *animations = [[content attributes] objectForKey:[KeyConstants animationsKey]];
        return [AnimationAttributesHelper animationEffectFromAnimationAttributes:animations event:event];
    } else {
        return AnimationEffectNone;
    }
}

- (AnimationParameters *) findAnimationParametersFromView:(UIView *) view event:(AnimationEvent) event
{
    if ([view isKindOfClass:[GenericContainerView class]]) {
        GenericContainerView *content = (GenericContainerView *) view;
        NSArray *animations = [[content attributes] objectForKey:[KeyConstants animationsKey]];
        return [AnimationAttributesHelper animationParametersFromAnimationAttributes:animations event:event];
    } else {
        return nil;
    }
    
}

@end
