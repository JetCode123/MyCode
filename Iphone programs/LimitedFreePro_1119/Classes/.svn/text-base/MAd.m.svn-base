//
//  MAd.m
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MAd.h"


@implementation MAd
@synthesize name;
@synthesize logo;
@synthesize sourceURL;
@synthesize wifiLogo;
@synthesize wifiLogoCache;
@synthesize isTodayUpdate;

-(void)dealloc{
	self.name = nil;
	self.logo = nil;
	self.sourceURL = nil;
	self.wifiLogo= nil;
	self.wifiLogoCache = nil;
	[super dealloc];
}

// 归档时用到。。
- (id) initWithCoder: (NSCoder*) coder
{
	if ((self = [super init]) != nil) {
		logo = [[coder decodeObjectForKey: @"logo"] retain];
		sourceURL = [[coder decodeObjectForKey: @"sourceURL"] retain];
		wifiLogo = [[coder decodeObjectForKey:@"wifiLogo"] retain];
		wifiLogoCache = [[coder decodeObjectForKey:@"wifiLogoCache"] retain];
	}
	return self;
}
- (void) encodeWithCoder: (NSCoder*) coder
{
	[coder encodeObject: logo forKey: @"logo"];
	[coder encodeObject: sourceURL forKey:@"sourceURL"];
	[coder encodeObject:wifiLogo forKey:@"wifiLogo"];
	[coder encodeObject:wifiLogoCache forKey:@"wifiLogoCache"];
}

@end
