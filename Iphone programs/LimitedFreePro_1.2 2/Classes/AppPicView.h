//
//  AppPicView.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPicListView.h"
#import "DataDownloader.h"

@interface AppPicView : UIView <DataDownloaderDelegate>{

	NSString *imageURL;
	NSInteger imageWidth;
	NSInteger imageHeight;
	
	AppPicListView *mainView;
	NSInteger index;
	BOOL isShow;
	
	DataDownloader *downloader;
	UIActivityIndicatorView *photoLoadView;
}

@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic) NSInteger imageWidth;
@property (nonatomic) NSInteger imageHeight;
@property (nonatomic,assign) AppPicListView *mainView;
@property (nonatomic) NSInteger index;

@property (nonatomic) BOOL isShow;
@property (nonatomic,retain) DataDownloader *downloader;
@property (nonatomic,retain) UIActivityIndicatorView *photoLoadView;

-(void)showImage;
-(void)setImageView:(UIImage *)img;
@end
