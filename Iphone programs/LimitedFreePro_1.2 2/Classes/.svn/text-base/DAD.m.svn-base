//
//  DAD.m
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// http://adshow.it168.com/ipadad/xianmian360/Index.html

#import "DAD.h"
#import "ADDelegate.h"

@implementation DAD

static int totalCount;
+ (NSMutableArray *) getADList{
	NSString *urlString = [NSString stringWithFormat:@"http://adshow.it168.com/ipadad/xianmian360/Index.html"];
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *xmlData = [NSData dataWithContentsOfURL:url];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	ADDelegate *categoryDelegate = [[ADDelegate alloc] init];										   
	
	[parser setDelegate:categoryDelegate];
	
	NSMutableArray *data = nil;
	
	if([parser parse] == YES){
		
		data = categoryDelegate.data;
		totalCount=categoryDelegate.totalCount;
	}
	
	[categoryDelegate release];
	[parser release];
	return data;	
}

+(NSInteger)getTotaolCount{
	int tempCount=totalCount;
	totalCount=0;

	return tempCount;
}
@end
