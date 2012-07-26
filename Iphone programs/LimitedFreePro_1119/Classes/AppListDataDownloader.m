//
//  AppListDataDownloader.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppListDataDownloader.h"
#import "Contants.h"
#import "NSObject+SBJson.h"
#import "MAppComment.h"

@implementation AppListDataDownloader

@synthesize delegate;
@synthesize _connection;
@synthesize _mutableData;
@synthesize _totalCount;
@synthesize _position;
@synthesize _type;


-(void)dealloc{
	self.delegate = nil;
	[self cancelDownload];
	self._connection = nil;
	
	self._mutableData = nil;
	[super dealloc];
}



// TODO:
-(void)getLimitedFreeAppWithIndex:(NSInteger)pageIndex andConDict:(NSMutableDictionary *)conList{
	int _startPosition = [[conList valueForKey:KEY_POSITION] intValue];
	int _categoryID = [[conList valueForKey:KEY_CATEGORYID] intValue];
	NSString *_orderStr = [conList valueForKey:KEY_ORDER];

	
	NSString *_urlStr = [NSString stringWithString:@"http://test2.app111.com/LimitedFree/LimitedFree%@-1-%i-%i-%i-%i.html?appid=457811949&version=1.1&mid=%@"];
	
	_urlStr = [NSString stringWithFormat:_urlStr,_orderStr,_categoryID,_startPosition,pageIndex,page_size,[[UIDevice currentDevice] uniqueIdentifier]];
	
	
	NSLog(@"%s,%d,url = %@",__FUNCTION__,__LINE__,_urlStr);
	
	[self startDownloadWithUrl:_urlStr];
}

-(void)startDownloadWithUrl:(NSString *)urlStr{
	NSURL *_url = [NSURL URLWithString:urlStr];
	NSURLRequest *_request = [NSURLRequest requestWithURL:_url
											  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										  timeoutInterval:KEY_TIMEOUT];
	self._mutableData = [NSMutableData data];
	self._connection = [NSURLConnection connectionWithRequest:_request delegate:self];
}

-(void)cancelDownload{
	[self._connection cancel];
	[self._mutableData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

		[self._mutableData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if(self.delegate != nil){
		[self.delegate downloadError:error];
		NSLog(@"Error is =%@=",[error localizedDescription]);
		NSLog(@"error code = %d",[error code]);
		
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{


		if(self._type == 1){
			[self parseAppFromJson:self._mutableData];
		}
		else if(self._type == 2){
			[self translate:self._mutableData];
		}
		
		
		else{
			[self parseAppListFromJson:self._mutableData];
		}


}



-(void)parseAppFromJson:(NSData *)jsonData{
	NSString *_jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *_dict = [_jsonStr JSONValue];
		
	MApp *app = [[[MApp alloc] init] autorelease];
    app._appHasVideo = [[_dict objectForKey:@"HasM3U8"] boolValue];
    
	app._appID = [_dict valueForKey:@"AppId"];
	app._appName = [_dict valueForKey:@"AppName"];
	app._appLogo = [_dict valueForKey:@"AppLogo"];
	
	app._appWifiLogo = [app._appLogo stringByReplacingOccurrencesOfString:@"80x80" withString:@"160x160"];
	app._appLogoPath = [app._appLogo lastPathComponent];
	app._appWifiLogoPath = [[app._appWifiLogo lastPathComponent] stringByAppendingString:@"wifi"];

	app._appCateName = [_dict valueForKey:@"AppCategoryName"];
	
//	NSString *summStr = [NSString stringWithFormat:@"%@",[_dict valueForKey:@"AppSummary"]];
//	NSLog(@"summStr.count = %d",summStr.length);
	
	app._appSummary = [_dict valueForKey:@"AppSummary"];
	app._appScore = [[_dict valueForKey:@"AppScore"] floatValue];

	
 	NSString *score = @"%.1f分";
	if(app._appScore == 10.0)
		score = @"%.f分";
	else if (app._appScore == 0.0)
		score = @"无评分";
	
	app._appSourceURL = [_dict valueForKey:@"AppSource"];
	app._appUpdateDate = [_dict valueForKey:@"AppUpdateTime"];
	app._appSize = [_dict valueForKey:@"AppSize"];
	
	app._appDropPrice = [[_dict valueForKey:@"AppPrice"] floatValue];
	if(app._appDropPrice > 0)
		app._appStrPrice = [NSString stringWithFormat:@"¥%.2f",app._appDropPrice];
	else
	{
		if(app._appPrice > 0)
			app._appStrPrice = [NSString stringWithFormat:@"¥%.2f",app._appPrice];
		else
			app._appStrPrice = [NSString stringWithFormat:@"免费"];
	}
	
	
	NSString *briefStr = [NSString stringWithFormat:@"%@",[_dict objectForKey:@"BriefSummary"]];
	
	NSInteger strLength = [briefStr length];
	NSString *theEndStr;
	if(strLength > 0){
		theEndStr = [briefStr substringFromIndex:(strLength - 1)];			// 包含本身索引处的字符。
	}
	
	else if(strLength == 0){
		theEndStr = nil;
	}
	
	if(![theEndStr isEqualToString:@"。"] && theEndStr != @"" && ![theEndStr isEqualToString:@"！"] && ![theEndStr isEqualToString:@" "]){
		briefStr = [briefStr stringByAppendingString:@"。"];
	}
	app._appBriefSummary = briefStr;
	
	app._appDownCount = [[_dict valueForKey:@"DownloadCount"] intValue];
	
	NSArray *_commentArray = [_dict objectForKey:@"AppComments"];
	if((NSNull *)_commentArray != [NSNull null]){
		app._appCommentList = [NSMutableArray array];
		
		for(NSDictionary *_commentDict in _commentArray){
			MAppComment *_comment = [[MAppComment alloc] init];
			_comment._commTitle = [_commentDict objectForKey:@"CommentTitle"];
			_comment._commContent = [_commentDict objectForKey:@"CommentContent"];
			_comment._commPubDate = [[_commentDict objectForKey:@"CommentTime"] substringToIndex:11];
            
//            NSLog(@"comment-time = %@",_comment._commPubDate);
			
			[app._appCommentList addObject:_comment];
			[_comment release];
		}
	}
	
	NSArray *_imgArray = [_dict objectForKey:@"AppImagesIphone"];
	if((NSNull *)_imgArray != [NSNull null]){
		app._appIPhoneImgWidth = [NSMutableArray array];
		app._appIPhoneImgHeight = [NSMutableArray array];
		
		app._appIPhonePictureList = [NSMutableArray array];
		
		for(NSDictionary *_imgDict in _imgArray){
			[app._appIPhoneImgWidth addObject:[_imgDict objectForKey:@"Width"]];
			[app._appIPhoneImgHeight addObject:[_imgDict objectForKey:@"Height"]];
			[app._appIPhonePictureList addObject:[_imgDict objectForKey:@"ImageUrl"]];
		}
	}
	
    
//    video shot picture code.
    app._appShotPictureURL = [_dict objectForKey:@"VideoShotPicture"];
    app._appShotPictureStr = [app._appShotPictureURL lastPathComponent];
    
    app._appVideoM3U8LinkURL = [_dict objectForKey:@"VideoM3U8Link"];
    NSLog(@"M3U8Link = %@",app._appVideoM3U8LinkURL);
    
    
	if(self.delegate != nil){
		[self.delegate detailDidLoad:app];
	}
}

-(NSInteger)getTotalCount{
	return self._totalCount;
}

-(NSInteger)getStartPosition{
	return self._position;
}

-(void)translate:(NSData *)data{
	NSString *_translateStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
	if(self.delegate != nil){
		[self.delegate translateDidLoad:_translateStr];
	}
}

-(void)parseAppListFromJson:(NSData *)jsonData{
	NSString *_jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSDictionary *_dict = [_jsonStr JSONValue];
	
	int pn = [[_dict objectForKey:@"StartPosition"] intValue];
	if(pn > 0){
		self._position = pn;
	}
	
	int tCount = [[_dict objectForKey:@"TotalCount"] intValue];
	if(tCount > 0){
		self._totalCount = tCount;
	}
	
	NSArray *_appListArr = [_dict objectForKey:@"AppListInfo"];
	NSMutableArray *_data = [[NSMutableArray alloc] init];
	
	for(int i = 0; i < [_appListArr count]; i++){
		NSDictionary *_appDict = [_appListArr objectAtIndex:i];
		MApp *_app = [[MApp alloc] init];
		
        _app._appHasVideo = [[_appDict objectForKey:@"HasM3U8"] boolValue];
        
		_app._appID = [_appDict objectForKey:@"AppId"];
		_app._appName = [_appDict objectForKey:@"AppName"];
		
		_app._appLogo = [_appDict objectForKey:@"AppLogo"];
		_app._appWifiLogo = [_app._appLogo stringByReplacingOccurrencesOfString:@"80x80" withString:@"160x160"];
		_app._appLogoPath = [_app._appLogo lastPathComponent];
		_app._appWifiLogoPath = [[_app._appWifiLogo lastPathComponent] stringByAppendingString:@"wifi"];
		
		
		_app._appPrice = [[_appDict objectForKey:@"AppPrice"] floatValue];
		_app._appDropPrice = [[_appDict objectForKey:@"AppDropPrice"] floatValue];
		
		if(_app._appDropPrice > 0){
			_app._appStrPrice = [NSString stringWithFormat:@"¥%.2f",_app._appDropPrice];
		}
		
		else{
			if(_app._appPrice > 0){
				_app._appStrPrice = [NSString stringWithFormat:@"¥%.2f",_app._appPrice];
			}
			else 
				_app._appStrPrice = [NSString stringWithFormat:@"Free"];
		}
		
		_app._appSize = [_appDict objectForKey:@"AppSize"];
		
		_app._appUpdateDate = [_appDict objectForKey:@"AppUpdateTime"];
		_app._appUpdateDateAll = _app._appUpdateDate;
		
		NSArray *_dateArr = [_app._appUpdateDate componentsSeparatedByString:@"-"];
		_app._appUpdateDate = [NSString stringWithFormat:@"%@月%@日",[_dateArr objectAtIndex:1],[_dateArr objectAtIndex:2]];
		
		_app._isIPadApp = 1;
		_app._isIPhoneApp = 0;
		
		_app._appIsNew = [[_appDict objectForKey:@"IsNewApp"] boolValue];
//        NSLog(@"_app._appIsNew = %d",_app._appIsNew);
        
        
		_app._appSourceURL = [_appDict objectForKey:@"AppSourceUrl"];
		
		_app._appScore = [[_appDict objectForKey:@"AppDecimalScore"] floatValue];
		
		NSString *score = @"%.1f分";
		if(_app._appScore == 10.0)
			score = @"%.0f分";
		else if(_app._appScore == 0.0)
			score = @"无评分";
		
		_app._appStrScore = [NSString stringWithFormat:score,_app._appScore];
		_app._appDownCount = [[_appDict objectForKey:@"DownloadCount"] intValue];
		_app._appCateName = [_appDict objectForKey:@"AppCategoryName"];
		
		NSString *briefStr = [NSString stringWithFormat:@"%@",[_appDict objectForKey:@"BriefSummary"]];
		
		NSInteger strLength = [briefStr length];
		NSString *theEndStr;
		if(strLength > 0){
			theEndStr = [briefStr substringFromIndex:(strLength - 1)];			// 包含本身索引处的字符。
		}
		
		else if(strLength == 0){
			theEndStr = nil;
		}
		
		if(![theEndStr isEqualToString:@"。"] && theEndStr != @"" && ![theEndStr isEqualToString:@"！"] && ![theEndStr isEqualToString:@" "]){
			briefStr = [briefStr stringByAppendingString:@"。"];
		}
		_app._appBriefSummary = briefStr;
		
		[_data addObject:_app];
		[_app release];
	}
	
	[_jsonStr release];
	
	if(self.delegate != nil)
		[self.delegate dataDidLoad:[_data autorelease]];
}

// go to line 73
-(void)getAppDetailByID:(NSString *)appID andType:(NSInteger)typeID{
    NSString *_urlStr = @"http://test2.app111.com/Common/Detail/%i/1/%@.html?appid=457811949&version=1.1&mid=%@";
	_urlStr = [NSString stringWithFormat:_urlStr,typeID,appID,[[UIDevice currentDevice] uniqueIdentifier]];	

	NSLog(@"应用详情 url %@\n",_urlStr);
	
	[self startDownloadWithUrl:_urlStr];
}

-(void)getTranslate:(NSString *)appID{
    NSString *_urlStr = @"http://www.app111.com/Service/Translator.asmx/TranslatorService?appid=%@&net4=%f";
	_urlStr = [NSString stringWithFormat:_urlStr,appID,arc4random()];
	
	NSLog(@"translate url str = %@",_urlStr);
	[self startDownloadWithUrl:_urlStr];
}

@end
