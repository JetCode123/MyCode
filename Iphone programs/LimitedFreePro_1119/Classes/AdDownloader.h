//
//  AdDownloader.h
//  限时免费_me
//
//  Created by lujiaolong on 11-9-16.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdDownloaderDelegate
-(void)getADApp:(NSMutableArray *)data;
@end

@interface AdDownloader : NSObject {
	id<AdDownloaderDelegate> delegate;
	NSURLConnection *_connection;
	NSMutableData *_mutableData;
	
	NSMutableDictionary *_conListDict;
	NSMutableArray *_adData;
}

@property (nonatomic,assign) id<AdDownloaderDelegate> delegate;

@property (nonatomic,retain) NSURLConnection *_connection;
@property (nonatomic,retain) NSMutableData *_mutableData;

@property (nonatomic,retain) NSMutableDictionary *_conListDict;
@property (nonatomic,retain) NSMutableArray *_adData;

-(void)getAdAppFromConList:(NSMutableDictionary *)conList;

-(void)startDownloadAdApp:(NSString *)urlStr;
-(void)parseAdAppFromJsonData:(NSData *)jsonData;
-(void)cancelDownload;

@end
