//
//  ProposalAttributesManager.m
//  iDo
//
//  Created by Huang Hongsen on 11/11/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "ProposalAttributesManager.h"
#import "DefaultValueGenerator.h"
#import "KeyConstants.h"
#import "Proposal+iDo.h"
#import "CoreDataManager.h"
static ProposalAttributesManager *sharedInstance;

@implementation ProposalAttributesManager

#pragma mark - Singleton
- (instancetype) init
{
    return nil;
}

- (instancetype) initInternal
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (ProposalAttributesManager *) sharedManager
{
    if (!sharedInstance) {
        sharedInstance = [[ProposalAttributesManager alloc] initInternal];
    }
    return sharedInstance;
}

#pragma mark - Slides Management
- (void) addNewSlideToProposal:(NSMutableDictionary *) proposal atIndex:(NSInteger) index
{
    [self addSlide:[DefaultValueGenerator defaultSlideAttributes] toProposal:proposal atIndex:index];
}

- (void) addSlide:(NSMutableDictionary *) slide toProposal:(NSMutableDictionary *)proposal atIndex:(NSInteger)index
{
    NSMutableArray *slides = proposal[[KeyConstants proposalSlidesKey]];
    [slides insertObject:slide atIndex:index];
//    [proposal setValue:[slides copy] forKey:[KeyConstants proposalSlidesKey]];
    [proposal setValue:@(index) forKey:[KeyConstants proposalCurrentSelectedSlideKey]];
}

- (void) saveSlide:(NSMutableDictionary *)slide toProposal:(NSMutableDictionary *)proposal
{
    NSMutableDictionary *originalSlide = [self findOriginalSlideForSlide:slide inProposal:proposal];
    [self updateOriginalAttributes:originalSlide withAttribtues:slide];
//    [[CoreDataManager sharedManager] saveProposalWithProposalChanges:proposal];
}

- (NSMutableDictionary *) findOriginalSlideForSlide:(NSMutableDictionary *)slide inProposal:(NSMutableDictionary *) proposal
{
    NSArray *slides = proposal[[KeyConstants proposalSlidesKey]];
    NSInteger slideUnique = [slide[[KeyConstants slideUniqueKey]] integerValue];
    for (NSMutableDictionary *originalSlide in slides) {
        NSInteger unique = [originalSlide[[KeyConstants slideUniqueKey]] integerValue];
        if (slideUnique == unique) {
            return originalSlide;
        }
    }
    return nil;
}

- (void) updateOriginalAttributes:(NSMutableDictionary *)originalAttributes withAttribtues:(NSMutableDictionary *)attributes
{
    for (NSString *key in [attributes allKeys]) {
        [originalAttributes setValue:attributes[key] forKey:key];
    }
}

@end
