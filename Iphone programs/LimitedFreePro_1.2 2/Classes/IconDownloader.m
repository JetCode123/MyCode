//
//  IconDownloader.m
//  TimeLimitFree
//	NSURLConnectionDelegate
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "IconDownloader.h"
#import "ImageCache.h"

@implementation IconDownloader

@synthesize _iconPath;
@synthesize _path;
@synthesize _indexPathInTableView;
@synthesize delegate;
@synthesize _activeDownload;
@synthesize _imgConnection;

-(void)dealloc{
	self._iconPath = nil;
	
	
	self._path = nil;
	
	self._indexPathInTableView = nil;
	
	[self._activeDownload release];
	self._activeDownload = nil;
	
	[self._imgConnection cancel];
	self._imgConnection= nil;
	[super dealloc];
}

-(void)startDownload{
	self._activeDownload = [NSMutableData data];
	NSURLConnection *_conn = [NSURLConnection connectionWithRequest:
							  [NSURLRequest requestWithURL:[NSURL URLWithString:self._iconPath]] delegate:self];
	self._imgConnection = _conn;
}

-(void)cancelDownload{
	[self._imgConnection cancel];
	self._imgConnection = nil;
	self._activeDownload= nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[self._activeDownload setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self._activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	self._imgConnection = nil;
	self._activeDownload = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	UIImage *_img = [[UIImage alloc] initWithData:self._activeDownload];
	//TODO: 缓存
    
	[ImageCache saveToCacheWithID:self._path andImg:_img andDir:DIR_LIST];
	
    [_img release];
	self._activeDownload = nil;
	
	self._imgConnection = nil;
	if(self.delegate != nil){
		[self.delegate appImageDidLoad:self._indexPathInTableView withPath:self._path];
	}
}

@end
