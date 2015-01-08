//
//  ProposalAttributesManager.h
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProposalDTO.h"
#import "SlideDTO.h"

@interface ProposalAttributesManager : NSObject

+ (ProposalAttributesManager *) sharedManager;

- (void) addNewSlideToProposal:(ProposalDTO *) proposal atIndex:(NSInteger) index;

- (void) addSlide:(SlideDTO *) slide toProposal:(ProposalDTO *)proposal atIndex:(NSInteger)index;

- (void) saveSlide:(SlideDTO *) slide toProposal:(ProposalDTO *) proposal;
@end
