//
//  AnimationOrderDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/7/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"
#import "AnimationConstants.h"
#import "Enums.h"
@interface AnimationOrderDTO : DataTransferObject
@property (nonatomic) ContentViewType viewType;
@property (nonatomic) AnimationEvent event;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *animationDescription;

@end
