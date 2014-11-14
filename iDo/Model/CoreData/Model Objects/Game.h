//
//  Game.h
//  iDo
//
//  Created by Huang Hongsen on 11/14/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Proposal;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) Proposal *proposal;

@end
