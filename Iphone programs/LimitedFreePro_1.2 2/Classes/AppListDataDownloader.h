//
//  AppListDataDownloader.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MApp.h"

@protocol AppListDataDownloaderDelegate
@optional

-(void)dataDidLoad:(NSMutableArray *)appArr;
-(void)detailDidLoad:(MApp *)app;
-(void)translateDidLoad:(NSString *)translateStr;
-(void)keywordIsNull;
-(void)downloadError:(NSError *)error;

-(NSArray *)adArrayWithAdData:(NSMutableArray *)data;
@end

@interface AppListDataDownloader : NSObject {

	id<AppListDataDownloaderDelegate> delegate;
	
	NSURLConnection *_connection;
	NSMutableData *_mutableData;
	
	NSInteger _totalCount; 
	NSInteger _position;
	NSInteger _type;
}

@property (nonatomic,assign) id<AppListDataDownloaderDelegate> delegate;
@property (nonatomic,retain) NSURLConnection *_connection;
@property (nonatomic,retain) NSMutableData *_mutableData;


@property (nonatomic) NSInteger	_totalCount;
@property (nonatomic) NSInteger _position;
@property (nonatomic) NSInteger _type;

-(void)getLimitedFreeAppWithIndex:(NSInteger)pageIndex andConDict:(NSMutableDictionary *)conList;

-(void)startDownloadWithUrl:(NSString *)urlStr;
-(void)cancelDownload;

-(void)parseAppListFromJson:(NSData *)jsonData;
-(void)parseAppFromJson:(NSData *)jsonData;

-(NSInteger)getTotalCount;
-(NSInteger)getStartPosition;

-(void)getAppDetailByID:(NSString *)appID andType:(NSInteger)typeID;
-(void)getTranslate:(NSString *)appID;
-(void)translate:(NSData *)data;


@end
