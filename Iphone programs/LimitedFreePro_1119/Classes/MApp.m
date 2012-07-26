//
//  MApp.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-23.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "MApp.h"


@implementation MApp

@synthesize _appID;
@synthesize _appName;

@synthesize _appLogo;
@synthesize _appWifiLogo;
@synthesize _appLogoPath;
@synthesize _appWifiLogoPath;

@synthesize _appPrice;
@synthesize _appDropPrice;
@synthesize _appScore;

@synthesize _appSize;
@synthesize _isIPadApp;
@synthesize _isIPhoneApp;

@synthesize _appIsNew;
@synthesize _appContent;

@synthesize _appCateName;
@synthesize _appUpdateDate;
@synthesize _appUpdateDateAll;

@synthesize _appDownCount;
@synthesize _appSummary;
@synthesize _appBriefSummary;
@synthesize _appSourceURL;
@synthesize _appRate;

@synthesize _appStrPrice;
@synthesize _appStrScore;
@synthesize _appLanguage;
@synthesize _appSummaryCN;
@synthesize _appDeveloper;

@synthesize _appIPhonePictureList;
@synthesize _appIPhoneImgWidth;
@synthesize _appIPhoneImgHeight;

@synthesize _appCommentList;

@synthesize _appHasVideo;

@synthesize _appShotPictureURL;
@synthesize _appShotPictureStr;

@synthesize _appVideoM3U8LinkURL;

-(void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder	encodeObject:self._appID forKey:@"AppID"];
	[aCoder encodeObject:self._appName forKey:@"name"];
	[aCoder encodeObject:self._appLogo forKey:@"logo"];
	[aCoder encodeObject:self._appLogoPath forKey:@"logoPath"];
	[aCoder encodeObject:self._appWifiLogo forKey:@"wifiLogo"];
	[aCoder encodeObject:self._appWifiLogoPath forKey:@"wifiLogoPath"];
	
	[aCoder encodeFloat:self._appPrice forKey:@"price"];
	[aCoder encodeFloat:self._appDropPrice forKey:@"dropPrice"];
	[aCoder encodeFloat:self._appScore forKey:@"score"];
	
	[aCoder encodeObject:self._appSize forKey:@"size"];
	[aCoder encodeBool:self._isIPadApp forKey:@"isIPad"];
	[aCoder encodeBool:self._isIPhoneApp forKey:@"isIPhone"];
	
	[aCoder encodeInteger:self._appIsNew forKey:@"appIsNew"];
	[aCoder encodeObject:self._appContent forKey:@"content"];
	[aCoder encodeObject:self._appCateName forKey:@"cateName"];
	[aCoder encodeObject:self._appUpdateDate forKey:@"update-date"];
	[aCoder encodeObject:self._appUpdateDateAll forKey:@"date-all"];
	
	[aCoder encodeInteger:self._appDownCount forKey:@"downCount"];
	[aCoder encodeObject:self._appSummary forKey:@"summary"];
	[aCoder encodeObject:self._appBriefSummary forKey:@"brief-summary"];
	[aCoder	encodeObject:self._appSourceURL forKey:@"source-url"];
	[aCoder encodeInteger:self._appRate forKey:@"rate"];
	[aCoder encodeObject:self._appStrPrice forKey:@"strPrice"];
	[aCoder encodeObject:self._appStrScore forKey:@"strScore"];
	[aCoder encodeObject:self._appLanguage forKey:@"language"];
	[aCoder encodeObject:self._appSummaryCN forKey:@"summaryCN"];
	[aCoder encodeObject:self._appDeveloper forKey:@"developer"];
	[aCoder encodeObject:self._appIPhonePictureList forKey:@"picList"];
	[aCoder encodeObject:self._appIPhoneImgWidth forKey:@"img-width"];
	[aCoder encodeObject:self._appIPhoneImgHeight forKey:@"img-height"];
	[aCoder encodeObject:self._appCommentList forKey:@"commentList"];
    
    [aCoder encodeBool:self._appHasVideo forKey:@"hasVideo"];
    
    [aCoder encodeObject:self._appShotPictureURL forKey:@"shotPictureURL"];
    [aCoder encodeObject:self._appShotPictureStr forKey:@"shotPictureStr"];
    
    [aCoder encodeObject:self._appVideoM3U8LinkURL forKey:@"M3U8"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	self = [[MApp alloc] init];
	if(self != nil){
		self._appID = [aDecoder decodeObjectForKey:@"AppID"];
		self._appName = [aDecoder decodeObjectForKey:@"name"];
		self._appLogo = [aDecoder decodeObjectForKey:@"logo"];
		self._appLogoPath = [aDecoder decodeObjectForKey:@"logoPath"];
		self._appWifiLogo = [aDecoder decodeObjectForKey:@"wifiLogo"];
		self._appWifiLogoPath = [aDecoder decodeObjectForKey:@"wifiLogoPath"];
		self._appPrice = [aDecoder decodeFloatForKey:@"price"];
		self._appDropPrice = [aDecoder decodeFloatForKey:@"dropPrice"];
		self._appScore = [aDecoder decodeFloatForKey:@"score"];
		self._appSize = [aDecoder decodeObjectForKey:@"size"];
		self._isIPadApp = [aDecoder decodeBoolForKey:@"isIPad"];
		self._isIPhoneApp = [aDecoder decodeBoolForKey:@"isIPhone"];
		
		self._appIsNew = [aDecoder decodeIntegerForKey:@"appIsNew"];
		self._appContent = [aDecoder decodeObjectForKey:@"content"];
		self._appCateName = [aDecoder decodeObjectForKey:@"cateName"];
		self._appUpdateDate = [aDecoder decodeObjectForKey:@"update-date"];
		self._appUpdateDateAll = [aDecoder decodeObjectForKey:@"date-all"];
		self._appDownCount = [aDecoder decodeIntegerForKey:@"downCount"];
		self._appSummary = [aDecoder decodeObjectForKey:@"summary"];
		self._appBriefSummary = [aDecoder decodeObjectForKey:@"brief-summary"];
		self._appSourceURL = [aDecoder decodeObjectForKey:@"sourcr-url"];
		self._appRate = [aDecoder decodeIntegerForKey:@"rate"];
		self._appStrPrice = [aDecoder decodeObjectForKey:@"strPrice"];
		self._appStrScore = [aDecoder decodeObjectForKey:@"strScore"];
		self._appLanguage = [aDecoder decodeObjectForKey:@"language"];
		self._appSummaryCN = [aDecoder decodeObjectForKey:@"summaryCN"];
		self._appDeveloper = [aDecoder decodeObjectForKey:@"developer"];
		self._appIPhonePictureList = [aDecoder decodeObjectForKey:@"picList"];
		self._appIPhoneImgWidth = [aDecoder decodeObjectForKey:@"img-width"];
		self._appIPhoneImgHeight = [aDecoder decodeObjectForKey:@"img-height"];
		self._appCommentList = [aDecoder decodeObjectForKey:@"commentList"];
        
        self._appHasVideo = [aDecoder decodeBoolForKey:@"hasVideo"];
        
        self._appShotPictureStr  =[aDecoder decodeObjectForKey:@"shotPictureStr"];
        self._appShotPictureURL  = [aDecoder decodeObjectForKey:@"shotPicutreURL"];
        
        self._appVideoM3U8LinkURL  =[aDecoder decodeObjectForKey:@"M3U8"];
	}
	return self;
}
-(void)dealloc{
	
	self._appID = nil;
	
	self._appName = nil;
	
	self._appLogo = nil;
	
	self._appWifiLogo = nil;
	
	self._appLogoPath = nil;
	
	self._appWifiLogoPath = nil;
	
	self._appSize = nil;
	
	self._appCateName = nil;
	
	self._appUpdateDate = nil;
	
	self._appUpdateDateAll = nil;

	self._appSummary = nil;
	
	self._appBriefSummary = nil;
	
	self._appSourceURL = nil;
	
	self._appStrPrice = nil;
	
	self._appStrScore = nil;
	
	self._appLanguage = nil;
	
	self._appSummaryCN = nil;
	
	self._appDeveloper = nil;
	
	self._appIPhonePictureList = nil;
	
	self._appIPhoneImgWidth = nil;
	
	self._appIPhoneImgHeight = nil;
	
	self._appCommentList = nil;
    [self._appShotPictureStr release];
    [self._appShotPictureURL release];
    
    [self._appVideoM3U8LinkURL release];
	[super dealloc];
}
@end
