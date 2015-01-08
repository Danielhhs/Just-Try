//
//  TextContent.h
//  iDo
//
//  Created by Huang Hongsen on 1/7/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GenericConent.h"


@interface TextContent : GenericConent

@property (nonatomic, retain) NSData * attributes;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * backgoundR;
@property (nonatomic, retain) NSNumber * backgoundG;
@property (nonatomic, retain) NSNumber * backgroundB;
@property (nonatomic, retain) NSNumber * backgroundA;

@end
