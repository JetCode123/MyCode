//
//  IconDownloader.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

// 列表图标下载类。。
#import <Foundation/Foundation.h>

@protocol IconDownloaderDelegate
-(void)appImageDidLoad:(NSIndexPath *)indexPath withPath:(NSString *)path;
@end

@interface IconDownloader : NSObject {
	NSString *_iconPath;
	NSString *_path;
	NSIndexPath *_indexPathInTableView;
	
	id<IconDownloaderDelegate> delegate;
	
	NSMutableData *_activeDownload;
	NSURLConnection *_imgConnection;
}

@property (nonatomic,retain) NSString *_iconPath;
@property (nonatomic,retain) NSString *_path;
@property (nonatomic,retain) NSIndexPath *_indexPathInTableView;
@property (nonatomic,assign) id<IconDownloaderDelegate> delegate;
@property (nonatomic,retain) NSMutableData *_activeDownload;
@property (nonatomic,retain) NSURLConnection *_imgConnection;

-(void)startDownload;
-(void)cancelDownload;

@end
