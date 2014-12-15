//
//  AnimationEditorManager.m
//  iDo
//
//  Created by Huang Hongsen on 12/12/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "AnimationEditorManager.h"
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
- (void) showAnimationEditorFromRect:(CGRect)rect inView:(UIView *)view forContent:(UIView *)content animationType:(AnimationEvent)animationEvent
{
    self.animationEditorContainer.animationTarget = content;
    self.animationEditorContainer.animationEvent = animationEvent;
    UIPopoverArrowDirection direction = UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp;
    if (animationEvent == AnimationEventBuiltIn) {
        direction = UIPopoverArrowDirectionRight | direction;
    } else {
        direction = UIPopoverArrowDirectionLeft | direction;
    }
    self.animationEditorPopover.popoverContentSize = CGSizeMake(250, 450);
    [self.animationEditorPopover presentPopoverFromRect:rect inView:view permittedArrowDirections:direction animated:YES];
}

@end
