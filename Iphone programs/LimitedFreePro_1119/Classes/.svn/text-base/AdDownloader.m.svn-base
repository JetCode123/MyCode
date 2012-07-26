//
//  AdDownloader.m
//  限时免费_me
//
//  Created by lujiaolong on 11-9-16.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AdDownloader.h"
#import "Contants.h"
#import "NSObject+SBJson.h"
#import "MAd.h"
#import "MApp.h"
#import "AppListCellView.h"

@implementation AdDownloader

@synthesize delegate;

@synthesize _connection;
@synthesize _mutableData;

@synthesize _conListDict;
@synthesize _adData;

-(void)dealloc{
	[self cancelDownload];
	
	self._connection = nil;
	self._mutableData = nil;
	self._conListDict = nil;
	self._adData = nil;
	
	[super dealloc];
}

-(void)getAdAppFromConList:(NSMutableDictionary *)conList{
	int _categoryID = [[conList valueForKey:KEY_CATEGORYID] intValue];
	NSString *_urlStr = [NSString stringWithString:@"http://jiekou.app111.com/LimitedFree/LimitedFree24H-1-%i-1-3.html?appid=457811949&version=v1.1&mid=%@"];
	_urlStr = [NSString stringWithFormat:_urlStr,_categoryID,[[UIDevice currentDevice] uniqueIdentifier]];
	
	NSLog(@"ad url = %@",_urlStr);
	
	[self startDownloadAdApp:_urlStr];
}

-(void)startDownloadAdApp:(NSString *)urlStr{
	NSURL *url = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										 timeoutInterval:KEY_TIMEOUT];
	
	self._mutableData = [NSMutableData data];
	self._connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)cancelDownload{
	[self._connection cancel];
	[self._mutableData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self._mutableData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[self parseAdAppFromJsonData:self._mutableData];
}

-(void)parseAdAppFromJsonData:(NSData *)jsonData{
	
	NSString *_jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *_dict = [_jsonStr JSONValue];
	
	NSArray *_adAppArray = [_dict objectForKey:@"AppListInfo"];
	self._adData = [NSMutableArray arrayWithCapacity:6];
	
	for(int i = 0; i < [_adAppArray count]; i++){
		NSDictionary *_adAppDict = [_adAppArray objectAtIndex:i];
		
		MApp *app = [[MApp alloc] init];
		app._appID = [_adAppDict objectForKey:@"AppId"];
		app._appName = [_adAppDict objectForKey:@"AppName"];
		app._appLogo = [_adAppDict objectForKey:@"AppLogo"];
		app._appWifiLogo = [app._appLogo stringByReplacingOccurrencesOfString:@"80x80" withString:@"160x160"];
		
		app._appLogoPath = [app._appLogo lastPathComponent];
		app._appWifiLogoPath = [[app._appWifiLogo lastPathComponent] stringByAppendingString:@"wifi"];
	
		app._appPrice = [[_adAppDict objectForKey:@"AppPrice"] floatValue];
		app._appDropPrice = [[_adAppDict objectForKey:@"AppDropPrice"] floatValue];
		
		if(app._appDropPrice > 0){
			app._appStrPrice = [NSString stringWithFormat:@"$%.2f",app._appDropPrice];
		}
		
		else{
			app._appStrPrice = [NSString stringWithFormat:@"Free"];
		}
		
		app._appSize = [_adAppDict objectForKey:@"AppSize"];
		app._appUpdateDate = [_adAppDict objectForKey:@"AppUpdateTime"];
		app._appUpdateDateAll = app._appUpdateDate;
		
		NSArray *dateArr = [app._appUpdateDate componentsSeparatedByString:@"-"];
		app._appUpdateDate = [NSString stringWithFormat:@"%月%日",[dateArr objectAtIndex:1],[dateArr objectAtIndex:2]];
		
		app._appIsNew = [[_adAppDict objectForKey:@"IsNewApp"] boolValue];
		app._appSourceURL = [_adAppDict objectForKey:@"AppSourceUrl"];
		app._appScore = [[_adAppDict objectForKey:@"AppDecimalScore"] floatValue];
		app._appStrScore = [_adAppDict objectForKey:@"AppScore"];
		app._appCateName = [_adAppDict objectForKey:@"AppCategoryName"];
		app._appBriefSummary = [_adAppDict objectForKey:@"BriefSummary"];
		
		
		[self._adData addObject:app];
		[app release];

	}
	
    id adDelegate = self.delegate;
    
	if(self.delegate != nil && [adDelegate respondsToSelector:@selector(getADApp:)]){
		[self.delegate getADApp:self._adData];
	}
}

@end
