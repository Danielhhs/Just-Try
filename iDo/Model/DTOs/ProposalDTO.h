//
//  ProposalDTO.h
//  iDo
//
//  Created by Huang Hongsen on 1/5/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import "DataTransferObject.h"
#import "SlideDTO.h"

@interface ProposalDTO : DataTransferObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSMutableArray *slides;
@property (nonatomic) NSInteger currentSelectedSlideIndex;

+ (ProposalDTO *) defaultProposal;
- (SlideDTO *) currentSlide;
- (SlideDTO *) nextSlide;
@end
