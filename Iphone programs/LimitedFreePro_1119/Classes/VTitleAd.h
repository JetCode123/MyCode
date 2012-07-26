//
//  VTitleAd.h
//  限时免费_me
//
//  Created by lujiaolong on 11-9-13.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdDownloader.h"

@protocol VTitleAdLoadingOverDelegate
-(void)titleAdViewLoadingOver;
@end

@class AppListViewController;

@class VFirstPageLogo;

@interface VTitleAd : UIView <AdDownloaderDelegate>{
	AppListViewController *_appListVC;
	NSMutableArray *_adArray;
	NSInteger _totalCount;
	NSMutableDictionary *_conListDict;
	NSInteger _page;
	NSString *_networkType; 
	
	VFirstPageLogo *logo;
	
	id<VTitleAdLoadingOverDelegate> delegate;
    BOOL hasPage;
}

@property (nonatomic,assign) id<VTitleAdLoadingOverDelegate> delegate;

@property (nonatomic,assign) AppListViewController *_appListVC;
@property (nonatomic,retain) NSMutableArray *_adArray;
@property (nonatomic) NSInteger _totalCount;
@property (nonatomic,retain) NSMutableDictionary *_conListDict;

@property (nonatomic) NSInteger _page;
@property (nonatomic,copy) NSString *_networkType;

@property (nonatomic) BOOL hasPage;

-(void)asynInit;
-(void)addImageView;

@end
