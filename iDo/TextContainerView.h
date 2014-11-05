//
//  TextContainerView.h
//  iDo
//
//  Created by Huang Hongsen on 10/15/14.
//  Copyright (c) 2014 com.microstrategy. All rights reserved.
//

#import "GenericContainerView.h"

@interface TextContainerView : GenericContainerView

@property (nonatomic, strong) NSAttributedString* text;

- (instancetype) initWithAttributes:(NSDictionary *) attributes;

- (void) startEditing;

- (void) adjustTextViewFrameAndContainerFrame;
@end
