//
//  Animation.h
//  iDo
//
//  Created by Huang Hongsen on 12/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GenericConent;

@interface Animation : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * triggerTime;
@property (nonatomic, retain) NSNumber * effect;
@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) GenericConent *container;

@end
