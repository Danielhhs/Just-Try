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
#import "GenericContainerView.h"
#import "GenericContentConstants.h"
#import "ImageContent+iDo.h"
#import "TextContent+iDo.h"
static SlideAttributesManager *sharedInstance = nil;
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

#pragma mark - Public APIs
- (void) addNewContent:(NSMutableDictionary *)content toSlide:(NSMutableDictionary *)slide
{
    NSMutableArray *contents = [slide[[KeyConstants slideContentsKey]] mutableCopy];
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

@end
