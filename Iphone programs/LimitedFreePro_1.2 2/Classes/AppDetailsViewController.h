//
//  AppDetailsViewController.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-31.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MApp.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "IconDownloader.h"
#import "MessageTool.h"
#import "AppListDataDownloader.h"
#import "AppPicListView.h"


@interface AppDetailsViewController : UIViewController <UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,
															UINavigationControllerDelegate,MBProgressHUDDelegate,AppListDataDownloaderDelegate,IconDownloaderDelegate>{
	MApp *_app;
	MApp *_nextApp;
	
	AppDetailsViewController *_nextDetailsVC;
	
																
	UILabel *titleLabel;
			
									
	UIView *_detailsViewOne;
	UIView *_detailsViewTwo;
	UIView *_detailCommentView;
	
                                                               
    UIView *videoView;
                                                                
	UIScrollView *_scrollView;
	
	UITextView *_summaryTextView;
	BOOL isEnglish;
	UIButton *_unfoldBtn;
	UIButton *_translateBtn;
	
	BOOL isLoad;
	
	UIButton *_bottomBackBtn;
	NSString *_translateCacheStr;
	NSInteger _summaryHeight;
	
	MBProgressHUD *_pageBoundHUD;
	NSInteger imageCornerSize;
	
	MessageTool *_messageTool;
	BOOL haveNetwork;
	AppListDataDownloader *_appListDownloader;
	IconDownloader *_iconDownloader;
	BOOL isNextLoading;
	
	AppPicListView *picListView;
																
	UIView *adView;
	NSOperationQueue *queue,*picqueue;
}

@property (nonatomic,retain) AppDetailsViewController *_nextDetailsVC;

@property (nonatomic,retain) NSOperationQueue *queue;
@property (nonatomic,retain) NSOperationQueue *picqueue;

@property (nonatomic,retain) UIView *adView;
@property (nonatomic,retain) AppPicListView *picListView;

@property (nonatomic,retain) MApp *_app;
@property (nonatomic,retain) MApp *_nextApp;
@property (nonatomic,retain) UIView *_detailsViewOne;
@property (nonatomic,retain) UIView *_detailsViewTwo;
@property (nonatomic,retain) UIView *_detailCommentView;

@property (nonatomic,retain) UIScrollView *_scrollView;
@property (nonatomic,retain) UITextView *_summaryTextView;

@property (nonatomic) BOOL isEnglish;
@property (nonatomic,retain) UIButton *_unfoldBtn;
@property (nonatomic,retain) UIButton *_translateBtn;
@property (nonatomic) BOOL isLoad;

@property (nonatomic,retain) UIButton *_bottomBackBtn;
@property (nonatomic,retain) NSString *_translateCacheStr;
@property (nonatomic) NSInteger _summaryHeight;
@property (nonatomic,retain) MBProgressHUD *_pageBoundHUD;
@property (nonatomic) NSInteger imageCornerSize;
@property (nonatomic,retain) MessageTool *_messageTool;
@property (nonatomic) BOOL haveNetwork;
@property (nonatomic,retain) AppListDataDownloader *_appListDownloader;
@property (nonatomic,retain) IconDownloader *_iconDownloader;
@property (nonatomic) BOOL isNextLoading;

@property (nonatomic,retain) UIView *videoView;

-(void)back;
-(void)redirectToApp;

-(void)showDetailOne;
-(void)showDetailTwo;
-(void)testMessage;

-(void)showTranslate;
-(void)changeFrame:(NSInteger)changeSize;
-(void)hideMessage;

-(void)BindDetailTwo;
-(void)showComment;

-(void)changeFrame;
-(void)translate;

-(void)showHUD;
-(void)alertWithTitle:(NSString *)title msg:(NSString *)msg;

-(float)TransAppScore:(float)value;

- (void)turnTheBackImage;
- (void)playAppVideo;
@end
