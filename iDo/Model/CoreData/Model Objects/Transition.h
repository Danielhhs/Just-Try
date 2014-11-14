//
//  Transition.h
//  iDo
//
//  Created by Huang Hongsen on 11/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Slide;

@interface Transition : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * event;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Slide *slide;

@end
