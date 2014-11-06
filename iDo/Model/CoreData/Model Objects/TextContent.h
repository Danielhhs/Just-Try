//
//  TextContent.h
//  iDo
//
//  Created by Huang Hongsen on 11/5/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GenericConent.h"


@interface TextContent : GenericConent

@property (nonatomic, retain) NSData * attributes;
@property (nonatomic, retain) NSString * text;

@end
