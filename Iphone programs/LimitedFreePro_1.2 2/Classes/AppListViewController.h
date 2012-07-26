//
//  AppListViewController.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "IconDownloader.h"
#import "AppListDataDownloader.h"
#import "MCategory.h"
#import "MessageTool.h"
#import "VTitleAd.h"


@class OrderView;
@class VIndicator;


@interface AppListViewController : UITableViewController<VTitleAdLoadingOverDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,IconDownloaderDelegate,AppListDataDownloaderDelegate> {
	NSMutableArray *_appListArr;
	NSInteger _currentPage;
	NSInteger _totalPage;
	NSMutableDictionary *_conListDict;
	NSInteger _totalCount;
	NSInteger _startPosition;
	BOOL isLoading;
	BOOL isReload;
	BOOL haveNetwork;
	
	EGORefreshTableHeaderView *_egoReloadHeaderView;
	UILabel *_bottomInfoLabel;
	UIView *_bottomLoadView;
	
	NSMutableDictionary *iconDownloadProgress;
	NSString *_networkType;
	
	MessageTool *_messageView;
	AppListDataDownloader *_appListDownloader;
	
	BOOL navStatus;
	UIView *_orderToolBar;
	
	MCategory *_category;
	NSIndexPath *_selectedIndex;
	
	OrderView *_ov;
	BOOL isOrderViewOn;

	UIScrollView *_adScrollView;
	VIndicator *_vIndicator;
	
	NSOperationQueue *loadImageQueue;
	NSOperationQueue *returnArrayQueue;
	VTitleAd *titleAdV;
	NSIndexPath *sectionIndexPath;	
    
    BOOL isTitleAdViewLoadOver;
    UIImageView *showImage;
}

@property (nonatomic,retain) UIImageView *showImage;

@property (nonatomic,retain) 	UIScrollView *_adScrollView;
@property (nonatomic,retain) VTitleAd *titleAdV;
@property (nonatomic,retain) NSIndexPath *sectionIndexPath;

@property (nonatomic,retain) VIndicator *_vIndicator;

@property (nonatomic,retain) NSMutableArray *_appListArr;
@property (nonatomic) NSInteger _currentPage;
@property (nonatomic) NSInteger _totalPage;
@property (nonatomic,retain) NSMutableDictionary *_conListDict;
@property (nonatomic) NSInteger _totalCount;
@property (nonatomic) NSInteger _startPosition;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL haveNetwork;

@property (nonatomic,retain) EGORefreshTableHeaderView *_egoReloadHeaderView;
@property (nonatomic,retain) UILabel *_bottomInfoLabel;
@property (nonatomic,retain) UIView *_bottomLoadView;
@property (nonatomic,retain) NSMutableDictionary *iconDownloadProgress;
@property (nonatomic,retain) NSString *_networkType;
@property (nonatomic,retain) MessageTool *_messageView;
@property (nonatomic,retain) AppListDataDownloader *_appListDownloader;

@property (nonatomic) BOOL navStatus;
@property (nonatomic,retain) UIView *_orderToolBar;
@property (nonatomic,retain) MCategory *_category;
@property (nonatomic,retain) NSIndexPath *_selectedIndex;

@property (nonatomic,retain) NSOperationQueue *loadImageQueue;
@property (nonatomic,retain) NSOperationQueue *returnArrayQueue;

@property BOOL isOrderViewOn;

@property (nonatomic) BOOL isTitleAdViewLoadOver;

-(void)networkChange;
-(void)showMessage;
-(void)hideMessage;

-(void)loadDataEnd:(NSMutableArray *)data;
-(void)showBottomInfo:(NSInteger)index;
-(void)doneLoadingTableViewData;

-(void)initHeaderView;
-(void)reloadData;
-(void)getDataByPageId:(NSInteger)page;
-(void)loadData;
-(void)loadImagesForOnscreenRows;
- (void)startIconDownload:(NSString *)path forIndexPath:(NSIndexPath *)indexPath logo:(NSString *)logo;
-(void)clickReload;

-(void)paixu_Action;
-(void)pushAction;

-(void)expandOut;
-(void)drawBack;


@end
