//
//  MCategory.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "MCategory.h"


@implementation MCategory

@synthesize _cateID;
@synthesize _cateName;
@synthesize _cateUpdateCount;
@synthesize _hasSubCategory;

-(void)dealloc{
	[self._cateName release];
	self._cateName = nil;
	
	[super dealloc];
}


@end
