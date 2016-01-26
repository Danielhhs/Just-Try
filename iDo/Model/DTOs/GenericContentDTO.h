//
//  GenericContentDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"
#import "Enums.h"
@interface GenericContentDTO : DataTransferObject
@property (nonatomic) CGPoint center;
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGFloat opacity;
@property (nonatomic) BOOL reflection;
@property (nonatomic) BOOL shadow;
@property (nonatomic) CGFloat reflectionAlpha;
@property (nonatomic) CGFloat reflectionSize;
@property (nonatomic) ContentViewShadowType shadowType;
@property (nonatomic) CGFloat shadowAlpha;
@property (nonatomic) CGFloat shadowSize;
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic) ContentViewType contentType;

+ (void) applyDefaultGenericContentToContentDTO:(GenericContentDTO *)content;
- (BOOL) shouldShowOnPlayingCanvasAppear;
@end
