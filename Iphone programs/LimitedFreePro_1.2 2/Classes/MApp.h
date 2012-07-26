//
//  MApp.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-23.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MApp : NSObject {

	NSString *_appID;
	NSString *_appName;
	
	NSString *_appLogo;
	NSString *_appWifiLogo;
	NSString *_appLogoPath;
	NSString *_appWifiLogoPath;
	
	float _appPrice;
	float _appDropPrice;
	float _appScore;
	
	NSString *_appSize;
	BOOL _isIPadApp;
	BOOL _isIPhoneApp;
	
	NSInteger _appIsNew;
	NSString *_appContent;
	
	NSString *_appCateName;
	NSString *_appUpdateDate;
	NSString *_appUpdateDateAll;
	
	NSInteger _appDownCount;
	NSString *_appSummary;
	NSString *_appBriefSummary;
	NSString *_appSourceURL;
	NSInteger _appRate;
	
	NSString *_appStrPrice;
	NSString *_appStrScore;
	NSString *_appLanguage;
	NSString *_appSummaryCN;
	NSString *_appDeveloper;
	
	NSMutableArray *_appIPhonePictureList;
	NSMutableArray *_appIPhoneImgWidth;
	NSMutableArray *_appIPhoneImgHeight;
	
	NSMutableArray *_appCommentList;
    
    BOOL _appHasVideo;
    NSString *_appShotPictureURL;
    NSString *_appShotPictureStr;
    
    NSString *_appVideoM3U8LinkURL;
}

@property (nonatomic,retain) NSString *_appID;
@property (nonatomic,retain) NSString *_appName;
@property (nonatomic,retain) NSString *_appLogo;
@property (nonatomic,retain) NSString *_appWifiLogo;
@property (nonatomic,retain) NSString *_appLogoPath;
@property (nonatomic,retain) NSString *_appWifiLogoPath;

@property (nonatomic) float _appPrice;
@property (nonatomic) float _appDropPrice;
@property (nonatomic) float _appScore;

@property (nonatomic,retain) NSString *_appSize;
@property (nonatomic) BOOL _isIPadApp;
@property (nonatomic) BOOL _isIPhoneApp;

@property (nonatomic) NSInteger _appIsNew;
@property (nonatomic,retain) NSString *_appContent;

@property (nonatomic,retain) NSString *_appCateName;
@property (nonatomic,retain) NSString *_appUpdateDate;
@property (nonatomic,retain) NSString *_appUpdateDateAll;
@property (nonatomic) NSInteger _appDownCount;
@property (nonatomic,retain) NSString *_appSummary;
@property (nonatomic,retain) NSString *_appBriefSummary;
@property (nonatomic,retain) NSString *_appSourceURL;
@property (nonatomic) NSInteger _appRate;
@property (nonatomic,retain) NSString *_appStrPrice;
@property (nonatomic,retain) NSString *_appStrScore;
@property (nonatomic,retain) NSString *_appLanguage;
@property (nonatomic,retain) NSString *_appSummaryCN;
@property (nonatomic,retain) NSString *_appDeveloper;

@property (nonatomic,retain) NSMutableArray *_appIPhonePictureList;
@property (nonatomic,retain) NSMutableArray	*_appIPhoneImgWidth;
@property (nonatomic,retain) NSMutableArray *_appIPhoneImgHeight;

@property (nonatomic,retain) NSMutableArray *_appCommentList;
@property (nonatomic) BOOL _appHasVideo;

@property (nonatomic,copy) NSString *_appShotPictureURL;
@property (nonatomic,copy) NSString *_appShotPictureStr;

@property (nonatomic,copy) NSString *_appVideoM3U8LinkURL;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

@end
