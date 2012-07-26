//
//  DataDownloader.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataDownloaderDelegate <NSObject>
-(void)dataDivLoad:(NSMutableData *)data url:(NSString *)url;
-(void)downloadError;
@end

@interface DataDownloader : NSObject {

	NSString *connectionURL;
	NSMutableData *mutableData;
	NSURLConnection *connection;
	
	id<DataDownloaderDelegate> delegate;
}

@property (nonatomic,retain) NSString *connectionURL;
@property (nonatomic,retain) NSMutableData *mutableData;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,assign) id <DataDownloaderDelegate> delegate;

-(void)startDownload:(NSString *)url;
-(void)cancelDownload;

@end
