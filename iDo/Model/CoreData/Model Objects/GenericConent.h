//
//  GenericConent.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Animation, Slide;

@interface GenericConent : NSManagedObject

@property (nonatomic, retain) NSData * bounds;
@property (nonatomic, retain) NSData * center;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * opacity;
@property (nonatomic, retain) NSNumber * reflection;
@property (nonatomic, retain) NSNumber * reflectionAlpha;
@property (nonatomic, retain) NSNumber * reflectionSize;
@property (nonatomic, retain) NSNumber * shadow;
@property (nonatomic, retain) NSNumber * shadowAlpha;
@property (nonatomic, retain) NSNumber * shadowSize;
@property (nonatomic, retain) NSNumber * shadowType;
@property (nonatomic, retain) NSData * transform;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *animations;
@property (nonatomic, retain) Slide *slide;
@end

@interface GenericConent (CoreDataGeneratedAccessors)

- (void)addAnimationsObject:(Animation *)value;
- (void)removeAnimationsObject:(Animation *)value;
- (void)addAnimations:(NSSet *)values;
- (void)removeAnimations:(NSSet *)values;

@end
