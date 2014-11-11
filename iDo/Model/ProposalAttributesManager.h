//
//  ProposalAttributesManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProposalAttributesManager : NSObject

+ (ProposalAttributesManager *) sharedManager;

- (void) addNewSlideToProposal:(NSMutableDictionary *) proposal atIndex:(NSInteger) index;

- (void) addSlide:(NSMutableDictionary *) slide toProposal:(NSMutableDictionary *)proposal atIndex:(NSInteger)index;

- (void) saveSlide:(NSMutableDictionary *) slide toProposal:(NSMutableDictionary *) proposal;
@end
