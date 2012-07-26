//
//  DataDownloader.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "DataDownloader.h"
#import "Contants.h"

@implementation DataDownloader
@synthesize connectionURL;
@synthesize mutableData;
@synthesize connection;
@synthesize delegate;

-(void)dealloc{
	self.connectionURL = nil;
	self.mutableData = nil;
	self.connection = nil;
	self.delegate = nil;
	
	[super dealloc];
}

-(void)startDownload:(NSString *)url{
	self.connectionURL = url;
	self.mutableData = [NSMutableData data];
	NSURL *URL = [NSURL URLWithString:self.connectionURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

-(void)cancelDownload{
	[self.connection cancel];
	self.connection = nil;
	self.mutableData = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self.mutableData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[self.delegate dataDivLoad:self.mutableData url:self.connectionURL];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self cancelDownload];
	
	[self.delegate downloadError];
}
@end
