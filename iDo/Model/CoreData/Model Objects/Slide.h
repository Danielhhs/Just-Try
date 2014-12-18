//
//  Slide.h
//  iDo
//
//  Created by Huang Hongsen on 12/18/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GenericConent, Proposal, Transition;

@interface Slide : NSManagedObject

@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSNumber * currentAnimationIndex;
@property (nonatomic, retain) NSSet *contents;
@property (nonatomic, retain) Proposal *proposal;
@property (nonatomic, retain) NSSet *transitions;
@end

@interface Slide (CoreDataGeneratedAccessors)

- (void)addContentsObject:(GenericConent *)value;
- (void)removeContentsObject:(GenericConent *)value;
- (void)addContents:(NSSet *)values;
- (void)removeContents:(NSSet *)values;

- (void)addTransitionsObject:(Transition *)value;
- (void)removeTransitionsObject:(Transition *)value;
- (void)addTransitions:(NSSet *)values;
- (void)removeTransitions:(NSSet *)values;

@end
