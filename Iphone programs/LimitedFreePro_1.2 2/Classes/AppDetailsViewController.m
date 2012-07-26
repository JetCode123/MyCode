//  AppDetailsViewController.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-31.
//  Copyright 2011 SequelMedia. All rights reserved.
//	UITouch 

#import "AppDetailsViewController.h"
#import "Contants.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCache.h"
#import "IconDownloader.h"
#import "ImageManipulator.h"
#import "AppCommentView.h"
#import "ShareController.h"
#import "VAD.h"
#import "MobClick.h"
#import "VShotPicture.h"
#import "PlayerViewController.h"

@implementation AppDetailsViewController

@synthesize _nextDetailsVC;

@synthesize queue,picqueue;

@synthesize picListView;

@synthesize adView;

@synthesize _app,_nextApp;
@synthesize _detailsViewOne;
@synthesize _detailsViewTwo;

@synthesize _detailCommentView;
@synthesize _scrollView;
@synthesize _summaryTextView;
@synthesize isEnglish;
@synthesize _unfoldBtn;
@synthesize _translateBtn;
@synthesize isLoad;

@synthesize _bottomBackBtn;
@synthesize _translateCacheStr;
@synthesize _summaryHeight;
@synthesize	_pageBoundHUD;
@synthesize imageCornerSize;
@synthesize _messageTool;
@synthesize haveNetwork;
@synthesize _appListDownloader;
@synthesize _iconDownloader;
@synthesize isNextLoading;

@synthesize videoView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
	self.queue = [[[NSOperationQueue alloc] init] autorelease];
	[self.queue setMaxConcurrentOperationCount:1];
	
	self.picqueue = [[[NSOperationQueue alloc] init] autorelease];
	[self.picqueue setMaxConcurrentOperationCount:1];
	
//	self.title = @"应用介绍";
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	label.center = CGPointMake(150, 22);
	label.text = @"应用介绍";
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:21];
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(1, 1);
	self.navigationItem.titleView = label;
	[label release];
	
	self.imageCornerSize = 26;
	self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
	
	self._appListDownloader = [[[AppListDataDownloader alloc] init] autorelease];
	self._appListDownloader.delegate = self;
	// 返回 
	UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_backBtn.frame = CGRectMake(0, 0, 61, 30);
	[_backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
	[_backBtn setTitle:@"  返 回" forState:UIControlStateNormal];
	_backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
	[_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backBtn] autorelease];
	
	// 下载
	UIButton *_downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_downloadBtn.frame = CGRectMake(0, 0, 48, 30);
	[_downloadBtn setBackgroundImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
	_downloadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
	[_downloadBtn setTitle:@"下 载" forState:UIControlStateNormal];
	[_downloadBtn addTarget:self action:@selector(redirectToApp) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_downloadBtn] autorelease];
	
	
	self._scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44)];
	
	self._detailsViewOne = [[UIView alloc] init];
	self._detailsViewOne.layer.borderColor = [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.2] CGColor];
	self._detailsViewOne.layer.borderWidth = 1;
	self._detailsViewOne.layer.cornerRadius = 8;
	    
    
//    if(self._app._appHasVideo){
//        self.videoView = [[UIView alloc] init];
//        self.videoView.layer.borderColor =  [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.2] CGColor];
//        self.videoView.layer.borderWidth = 1;
//        self.videoView.layer.cornerRadius = 8;
//        [self._scrollView addSubview:self.videoView];
//    }

    
	self._detailsViewTwo = [[UIView alloc] init];
	self._detailsViewTwo.layer.borderColor = [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.2] CGColor];
	self._detailsViewTwo.layer.borderWidth = 1;
	self._detailsViewTwo.layer.cornerRadius = 8;
	
	//评论块
	self._detailCommentView = [[UIView alloc] init];
	self._detailCommentView.layer.borderColor = [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.2] CGColor];
	self._detailCommentView.layer.borderWidth = 1;
	self._detailCommentView.layer.cornerRadius = 8;
	
	self._summaryTextView = [[UITextView alloc] init];
	self._summaryTextView.userInteractionEnabled = NO;
	self._summaryTextView.font = [UIFont systemFontOfSize:13.f];
	self._summaryTextView.backgroundColor = [UIColor clearColor];
    
	self._summaryTextView.frame = CGRectMake(5, 3, 290, 75 - 1);
	self._summaryHeight = self._summaryTextView.frame.size.height;
	
	// addSubview
	[self.view addSubview:self._scrollView];
	[self._scrollView addSubview:self._detailsViewOne];
    
	[self._scrollView addSubview:self._detailsViewTwo];
	[self._scrollView addSubview:self._detailCommentView];
	
	[self._detailsViewTwo addSubview:self._summaryTextView];
	
	[self._summaryTextView release];
	[self._detailsViewOne release];
	[self._detailsViewTwo release];
	[self._detailCommentView release];

	
	[self._scrollView release];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if(!self.isLoad){
		self.isLoad = YES;
		[self showDetailOne];
		if(self.haveNetwork){
			[self showDetailTwo];
		}
		else{
			self._messageTool = [[[MessageTool alloc] initWithView:self.view] autorelease];
			[self._messageTool showNetworkStatus:self.haveNetwork];
			[self performSelector:@selector(hideMessage) withObject:self afterDelay:2];
		}
	}
}
-(void)back{
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)showDetailOne{ 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 76, 76)];
    imgView.tag = 11;
    imgView.image = [UIImage imageNamed:@"mask_dark_y.png"];
    [self._detailsViewOne addSubview:imgView];
    [imgView release];
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    iv.tag = 22;
    iv.frame = CGRectMake(15 + 76 / 2 - 9, 15 + 76 / 2 - 9, 18, 18);
    [iv startAnimating];
    [self._detailsViewOne addSubview:iv];
    [iv release];
    
	UIImage *icon = [ImageCache loadFromCacheWithID:self._app._appWifiLogoPath andDir:DIR_LIST];
	if(!icon){
		_iconDownloader = [[IconDownloader alloc] init];
		_iconDownloader.delegate = self;
		if([[[NSUserDefaults standardUserDefaults] stringForKey:Key_NetworkType] isEqualToString:@"Wifi"]){
			_iconDownloader._iconPath = self._app._appWifiLogo;
			_iconDownloader._path = self._app._appWifiLogoPath;
		}
		else if([[[NSUserDefaults standardUserDefaults] stringForKey:Key_NetworkType] isEqualToString:@"3g"]){
			imageCornerSize = 13;
			icon = [ImageCache loadFromCacheWithID:self._app._appLogoPath andDir:DIR_LIST];
			if(!icon){
				_iconDownloader._iconPath = self._app._appLogo;
				_iconDownloader._path = self._app._appLogoPath;
			}
		}
		
		_iconDownloader._indexPathInTableView = [[[NSIndexPath alloc] initWithIndex:0] autorelease];
		[_iconDownloader startDownload];
	}
	
	if(icon){
        
        UIImageView *imgV = (UIImageView *)[self._detailsViewOne viewWithTag:11];
        if(imgV)
            [imgV removeFromSuperview];
         
        UIActivityIndicatorView *iv = (UIActivityIndicatorView *)[self._detailsViewOne viewWithTag:22];
        if(iv)
            [iv removeFromSuperview];
    
		icon = [ImageManipulator makeRoundCornerImage:icon :imageCornerSize :imageCornerSize];
		UIImageView *logoView = [[[UIImageView alloc] initWithImage:icon] autorelease];
		logoView.frame = CGRectMake(15, 15, 76, 76);
		[self._detailsViewOne addSubview:logoView];
		[icon release];
	}
	
	// 标题
	titleLabel = [[[UILabel alloc] init] autorelease];
	titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
	titleLabel.text = self._app._appName;
	titleLabel.adjustsFontSizeToFitWidth = NO;
	CGSize size = [titleLabel.text sizeWithFont:titleLabel.font];
	if(size.width >= 270){
		size.width = 270;
	}
	titleLabel.frame = CGRectMake(15 + 95, 7, size.width, size.height);
	[self._detailsViewOne addSubview:titleLabel];
	
	// 分类
	UILabel *cateLabel = [[[UILabel alloc] init] autorelease];
	cateLabel.frame = CGRectMake(110, 31, 200, 14);
	cateLabel.font = [UIFont systemFontOfSize:13.f];
	cateLabel.text = [@"分类: " stringByAppendingString:self._app._appCateName];
	[self._detailsViewOne addSubview:cateLabel];
	
	// 大小
	UILabel *sizeLabel = [[[UILabel alloc] init] autorelease];
	sizeLabel.frame = CGRectMake(110, cateLabel.frame.origin.y + KEY_DETAIL_INFO_JIANJU, 200, 14);
	sizeLabel.font = [UIFont systemFontOfSize:13.f];
	sizeLabel.text = [@"大小: " stringByAppendingString:self._app._appSize];
	[self._detailsViewOne addSubview:sizeLabel];
	
	// 得分
	UILabel *scoreLabel = [[[UILabel alloc] init] autorelease];
	scoreLabel.frame = CGRectMake(110, sizeLabel.frame.origin.y + KEY_DETAIL_INFO_JIANJU, 200, 14);
	scoreLabel.font = [UIFont systemFontOfSize:13.f];
	
	//scoreLabel.text = [@"评分: " stringByAppendingFormat:@"%.1f分",[self TransAppScore:_app._appScore]];
	scoreLabel.text = [@"评分: " stringByAppendingFormat:@"%.1f分",_app._appScore];
	if([self TransAppScore:_app._appScore] == 0.f)
		scoreLabel.text = [@"评分: " stringByAppendingString:@"无评分"];
	[self._detailsViewOne addSubview:scoreLabel];
	
	// 时间
	UILabel *limitedTimeLabel = [[[UILabel alloc] init] autorelease];
	limitedTimeLabel.frame = CGRectMake(110, scoreLabel.frame.origin.y + KEY_DETAIL_INFO_JIANJU, 200, 14);
	limitedTimeLabel.font = [UIFont systemFontOfSize:13.f];
	
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd"];
	
	NSString *todayStr = [df stringFromDate:[NSDate date]];
	NSString *yesterdayStr = [df stringFromDate:[NSDate dateWithTimeInterval:-(24 * 60 * 60) sinceDate:[NSDate date]]];
	
	if([self._app._appUpdateDateAll isEqualToString:todayStr]){
		self._app._appUpdateDateAll = @"今日限免";
	}
	
	if([self._app._appUpdateDateAll isEqualToString:yesterdayStr]){
		self._app._appUpdateDateAll = @"昨日限免";
	}
	
	limitedTimeLabel.text = [@"时间: " stringByAppendingString:self._app._appUpdateDateAll];
	[self._detailsViewOne addSubview:limitedTimeLabel];
	
	UIButton *shareBtn = [[[UIButton alloc] init] autorelease];
	shareBtn.frame = CGRectMake(110, limitedTimeLabel.frame.origin.y + KEY_DETAIL_INFO_JIANJU+ 3, 75, 35);
	[shareBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share" ofType:@"png"]] forState:UIControlStateNormal];
	[shareBtn addTarget:self action:@selector(testMessage) forControlEvents:UIControlEventTouchUpInside];
	[self._detailsViewOne addSubview:shareBtn];
	
	UILabel *dollarLabel = [[[UILabel alloc] init] autorelease];
	dollarLabel.frame = CGRectMake(15, 100, 70, 20);
	dollarLabel.font = [UIFont systemFontOfSize:16.f];
	dollarLabel.backgroundColor = [UIColor clearColor];
	dollarLabel.textAlignment = UITextAlignmentCenter;
	dollarLabel.text = self._app._appStrPrice;
	dollarLabel.textColor = [UIColor colorWithRed:0.325 green:0.620 blue:0.827 alpha:1];
	[self._detailsViewOne addSubview:dollarLabel];
	
//	UIView *sepratorView = [[[UIView alloc] init] autorelease];
//	sepratorView.frame = CGRectMake(0, 0, 50, 1);
//	sepratorView.backgroundColor = [UIColor lightGrayColor];
//	sepratorView.center = CGPointMake(50, 130);
//	sepratorView.transform = CGAffineTransformMakeRotation(M_PI / 12);
//	[self._detailsViewOne addSubview:sepratorView];
	
	UIImageView *img = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 13)] autorelease];
	img.image = [UIImage imageNamed:@"xixian.png"];
	img.center = CGPointMake(50, 110);
	[self._detailsViewOne addSubview:img];
	
	
	self._detailsViewOne.frame = CGRectMake(10, 10, 300, 145);
	[pool release];
}

-(void)showDetailTwo{
	//NSLog(@"%s,%d",__FUNCTION__,__LINE__);
	self._messageTool = [[[MessageTool alloc] initWithView:self.view] autorelease];
	[self._messageTool insertLoading:@"正在加载数据"];
	
	self._appListDownloader._type = 1;
	[self._appListDownloader getAppDetailByID:self._app._appID andType:2];
}

-(void)redirectToApp{ 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self._app._appSourceURL]];
	
	[self performSelector:@selector(updateDownloadCount:) withObject:self._app._appID];
}

-(void)updateDownloadCount:(NSString *)appID{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://xml.app111.com/home/updateAppDownloadCountiPhone"]];
	[request setHTTPMethod:@"POST"];
	
	NSData *body = [[NSString stringWithFormat:@"Appid=%@&Type=1&iCode=%@",appID,[[UIDevice currentDevice] uniqueIdentifier]] dataUsingEncoding:NSUTF8StringEncoding];		
	[request setHTTPBody:body];
	
	NSURLResponse *response;
	NSError *error;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
	NSDictionary *dict = [httpRes allHeaderFields];
	NSLog(@"uploadDownloadCount ====== %@",dict);

	[MobClick event:@"下载"];

}

// viewDidAppear(haveNetwork)--->showDetailTwo--->getAppDetailByID andType:--->delegate(parseAppFromJson)--->detailDidLoad:
-(void)detailDidLoad:(MApp *)app{
//  调用详情页的接口时没有--（HasVideo字段）,所以返回null.
	app._appName = self._app._appName;
	app._appLogo = self._app._appLogo;
	app._appSourceURL = self._app._appSourceURL;
	app._appDropPrice = self._app._appDropPrice;
	app._appLogoPath = self._app._appLogoPath;
	app._appWifiLogoPath = self._app._appWifiLogoPath;
	app._appStrPrice = self._app._appStrPrice;
	app._appCateName = self._app._appCateName;
	app._appUpdateDateAll = self._app._appUpdateDateAll;
	app._appSize = self._app._appSize;
    app._appHasVideo = self._app._appHasVideo;
   

	self._app = app;
	self._app._appVideoM3U8LinkURL = app._appVideoM3U8LinkURL;
    
    
	self.isEnglish = YES;
	for(int i = 0; i < [self._app._appSummary length]; i++){
		int c = [self._app._appSummary characterAtIndex:i];
		if(c > 19968 && c < 40895){
			self.isEnglish = NO;
			break;
		}
	}
	
	[self performSelectorOnMainThread:@selector(BindDetailTwo) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(showComment) withObject:nil waitUntilDone:YES];
}

-(void)setupTheVideoView{
    VShotPicture *mShotPicture = [[VShotPicture alloc] initWithFrame:CGRectMake(20, 5, self.videoView.frame.size.width - 40, self.videoView.frame.size.height - 10)];
    mShotPicture.tag = 10101;
    mShotPicture.app = self._app;
    mShotPicture._detailsVC = self;
    
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:mShotPicture withObject:nil];

    [self.videoView addSubview:mShotPicture];
    [mShotPicture release];
}

- (void)turnTheBackImage{
    VShotPicture *shotPict = (VShotPicture *)[self.videoView viewWithTag:10101];
    shotPict.mBackImgView.image = [UIImage imageNamed:@"video.png"];
    
    [self performSelector:@selector(playAppVideo) withObject:nil afterDelay:0.6];
}

- (void)playAppVideo {

    NSLog(@"url = %@LINK",self._app._appVideoM3U8LinkURL);
    NSLog(@"URL是否为空== %d",[self._app._appVideoM3U8LinkURL isEqualToString:@" "]);
    
    self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
    NSLog(@"self.haveNetwork = %d",self.haveNetwork);
    
    if(self.haveNetwork){
        if(![self._app._appVideoM3U8LinkURL isEqualToString:@" "]){
            PlayerViewController *playerVC = [[PlayerViewController alloc] init];
            playerVC.videoURL = [NSURL URLWithString:[NSString stringWithString:self._app._appVideoM3U8LinkURL]];
	
			
			[self presentModalViewController:playerVC animated:YES];
			[playerVC readyPlayer];

            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
            [playerVC release]; 
        
            [MobClick event:@"播放视频" label:self._app._appName];
        }
    }
    
    else{
        if(!self._messageTool){
            self._messageTool = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
            [self._messageTool showNetworkStatus:self.haveNetwork];
            [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
        }
    }
    
    VShotPicture *shotPicture = (VShotPicture *)[self.videoView viewWithTag:10101];
    shotPicture.mBackImgView.image = [UIImage imageNamed:@"iphone_sp.png"];
}

-(void)BindDetailTwo{
	[self hideMessage];
	if(self._app._appBriefSummary != nil && [self._app._appBriefSummary length] > 0){
		UIImageView *fenjiexian = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
		fenjiexian.frame = CGRectMake(15, 145, 270, 2);
		[self._detailsViewOne addSubview:fenjiexian];
		[fenjiexian release];
		
		UITextView *_tv = [[UITextView alloc] init];
		
		UILabel *_label = [[UILabel alloc] init];
		_label.text = @"一句话简介:";
		_label.font = [UIFont boldSystemFontOfSize:13];
		CGSize size = [_label.text sizeWithFont:_label.font];
		_label.frame = CGRectMake(6, 8, size.width, size.height);
		_label.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1];
		_label.backgroundColor = [UIColor clearColor];
		
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        
		_tv.frame = CGRectMake(5, 15, 290, 40);
        if(systemVersion >= 5.0){
            _tv.text = [@"                    " stringByAppendingString:self._app._appBriefSummary];
        }
        else if(systemVersion < 5.0){
            _tv.text = [@"                  " stringByAppendingString:self._app._appBriefSummary];

        }
		_tv.font = [UIFont systemFontOfSize:13];
		_tv.backgroundColor = [UIColor clearColor];
		_tv.userInteractionEnabled = NO;
		[_tv addSubview:_label];
		[_label release];
		
		[self._detailsViewOne addSubview:_tv];
		[_tv release];
		
		_tv.frame = CGRectMake(10, 145, 290, _tv.contentSize.height);
		self._detailsViewOne.frame = CGRectMake(10, 10, 300, self._detailsViewOne.frame.size.height + _tv.frame.size.height);
    
        if(self._app._appHasVideo){
            UIView *_aview = [[UIView alloc] initWithFrame:CGRectMake(5, _tv.frame.origin.y + _tv.frame.size.height - 3, 290, 195)];
            self.videoView = _aview;
            [self._detailsViewOne addSubview:self.videoView];
            [_aview release];
            
            [self setupTheVideoView];
        
            self._detailsViewOne.frame = CGRectMake(10, 10, 300, self.videoView.frame.origin.y + self.videoView.frame.size.height + 10);
        }
	}
	
	CGFloat height = 0.f;
	//显示简介
	
	self._summaryTextView.text = self._app._appSummary;
	if(self._summaryTextView.frame.size.height >= self._summaryTextView.contentSize.height){
		self._summaryTextView.frame = CGRectMake(5, 3, 290, self._summaryTextView.contentSize.height);
	}
	else{
		self._unfoldBtn = [[[UIButton alloc] init] autorelease];
		[self._unfoldBtn addTarget:self action:@selector(changeFrame) forControlEvents:UIControlEventTouchUpInside];
		UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zhankai" ofType:@"png"]];
		[self._unfoldBtn setBackgroundImage:image forState:UIControlStateNormal];
		
		height = self._summaryTextView.frame.size.height + self._summaryTextView.frame.origin.y + 10;
		self._unfoldBtn.frame = CGRectMake(225, height, 60, 28);
		[self._detailsViewTwo addSubview:self._unfoldBtn];
	}
	
	if(self.isEnglish){
		self._translateBtn = [[[UIButton alloc] init] autorelease];
		[self._translateBtn addTarget:self action:@selector(translate) forControlEvents:UIControlEventTouchUpInside];
		[self._translateBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yizhongwen" ofType:@"png"]] forState:UIControlStateNormal];
		height = self._summaryTextView.frame.size.height + self._summaryTextView.frame.origin.y + 10;
		
		self._translateBtn.frame = CGRectMake(15, height, 90, 28);
		[self._detailsViewTwo addSubview:self._translateBtn];
	}
	
	CGFloat plist_y = self._unfoldBtn.frame.origin.y + self._unfoldBtn.frame.size.height + 10;
	if(self._unfoldBtn == nil){
		plist_y = self._translateBtn.frame.origin.y + self._translateBtn.frame.size.height + 10;
	}
	
	if(self._unfoldBtn == nil && self._translateBtn == nil){
		plist_y = self._summaryTextView.frame.origin.y + self._summaryTextView.frame.size.height + 10;
	}
	
	int picCount = [self._app._appIPhonePictureList count];
	CGFloat plist_height = 380 * picCount + 10 * (picCount - 1);
	CGRect frame = CGRectMake(20, plist_y, 260, plist_height);
	
	self.picListView = [[[AppPicListView alloc] initWithFrame:frame] autorelease];
	self.picListView.detailController = self;
	self.picListView.application = self._app;
	[self.picListView showImages];
	
	[self._detailsViewTwo addSubview:self.picListView];
	
	height = self._detailsViewOne.frame.origin.y + self._detailsViewOne.frame.size.height + 10;

    self._detailsViewTwo.frame = CGRectMake(10, height, 300, picListView.frame.origin.y + picListView.frame.size.height + 10);
    self._scrollView.contentSize = CGSizeMake(320, self._detailsViewTwo.frame.origin.y + self._detailsViewTwo.frame.size.height + 10);
}

-(void)translate{
	if(!self.haveNetwork){
		if(!self._messageTool){
            if(!self._messageTool){
                
                self._messageTool = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
                [self._messageTool showNetworkStatus:self.haveNetwork];
                [self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
            }
		}
		return;
	}
	
	if(self._translateCacheStr == nil){
		if(!self._messageTool){
			self._messageTool = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
			[self._messageTool showLoading:@"正在翻译..."];
			self._appListDownloader._type = 2;
			[self._appListDownloader getTranslate:self._app._appID];
		}
	}
	
	else{
		[self showTranslate];
	}
	
	[MobClick event:@"翻译"];
}

-(void)changeFrame{
	[self changeFrame:0];
}

-(void)showComment{
	// 评论数组
	//	NSLog(@"app-commentList = %@",self._app._appCommentList);
	
	if(self._app._appCommentList != nil && [self._app._appCommentList count] > 0){
		int height = 5;
		for(int i = 0; i < [self._app._appCommentList count]; i++){
			AppCommentView *commentView = [[AppCommentView alloc] init];
			commentView._currentAppComment = [self._app._appCommentList objectAtIndex:i];
			[commentView bindItem];
			
			int frameHeight = commentView._contentTextView.frame.size.height + commentView._contentTextView.frame.origin.y;
			commentView.frame = CGRectMake(10 ,height, 280, frameHeight);
			[self._detailCommentView addSubview:commentView];
			[commentView release];
			height += frameHeight;
		}
		
		CGFloat y = self._detailsViewTwo.frame.origin.y + self._detailsViewTwo.frame.size.height + 10;
		self._detailCommentView.frame = CGRectMake(10, y, 300, height);
		y = self._detailCommentView.frame.origin.y + self._detailCommentView.frame.size.height + 10;
		self._scrollView.contentSize = CGSizeMake(320, y);
	}
	
	self._bottomBackBtn = [[[UIButton alloc] init] autorelease];
	[self._bottomBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	self._bottomBackBtn.frame = CGRectMake(25, self._scrollView.contentSize.height, 270, 43);
	[self._bottomBackBtn setBackgroundImage:[UIImage imageNamed:@"fanhui_2.png"] forState:UIControlStateNormal];
	[self._scrollView addSubview:_bottomBackBtn];
	
//	self.adView = [[UIView alloc] init];
//	self.adView.frame = CGRectMake(10, self._bottomBackBtn.frame.origin.y + self._bottomBackBtn.frame.size.height + 10, 300, 107);
//    self.adView.layer.borderWidth = 1;
//    self.adView.layer.borderColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.2].CGColor;
//    self.adView.layer.cornerRadius = 8;
//	[self._scrollView addSubview:self.adView];
//	[self.adView release];
//	
//	VAD *vad = [[VAD alloc] initWithFrame:CGRectMake(10, 10, self.adView.frame.size.width, self.adView.frame.size.height)];
//	vad.appDetailController = self;
//	[vad asynInit];
//	[self.adView addSubview:vad];
//	[vad release];
//	
//	self._scrollView.contentSize = CGSizeMake(320, self.adView.frame.origin.y + self.adView.frame.size.height + 20);
	
	self._scrollView.contentSize = CGSizeMake(320, self._bottomBackBtn.frame.origin.y + self._bottomBackBtn.frame.size.height + 20);
	
//	if(!self.isNextLoading){
//		self._nextDetailsVC = [[[AppDetailsViewController alloc] init] autorelease];
//		self._nextDetailsVC._app = self._nextApp;
//		self._nextDetailsVC.isNextLoading = YES;
//		[self._nextDetailsVC showDetailTwo];
//	}
}

# pragma mark IconDownloader delegate.
-(void)appImageDidLoad:(NSIndexPath *)indexPath withPath:(NSString *)path{
	UIImage *icon = [ImageCache loadFromCacheWithID:path andDir:DIR_LIST];
	icon = [ImageManipulator makeRoundCornerImage:icon :imageCornerSize :imageCornerSize];
	UIImageView *logoView = [[[UIImageView alloc] initWithImage:icon] autorelease];
	logoView.frame = CGRectMake(15, 15, 76, 76);
	[self._detailsViewOne addSubview:logoView];
	[icon release];
}

# pragma mark AppListDataDownloader Delegate. 
-(void)translateDidLoad:(NSString *)translateStr{
	translateStr = [translateStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
	self._translateCacheStr = translateStr;
	
	[self showTranslate];
}

-(void)downloadError:(NSError *)error{
	NSLog(@"translate error code = %i",[error code]);
	
	[self hideMessage];
	self._messageTool = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
	if([error code] == - 1009){
//		[self._messageTool showLoading:@"网络已断开"];
        [self._messageTool showNetworkStatus:0];
	}
	else{
		[self._messageTool showLoading:@"请求超时，请重试"];
	}
	[self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
}

-(void)showTranslate{
	[self hideMessage];
	if([self._summaryTextView.text isEqualToString:self._translateCacheStr]){
		self._summaryTextView.text = self._app._appSummary;
		[self._translateBtn setBackgroundImage:[UIImage imageNamed:@"yizhongwen.png"] forState:UIControlStateNormal];
	}
	
	else{
		self._summaryTextView.text = self._translateCacheStr;
		[self._translateBtn setBackgroundImage:[UIImage imageNamed:@"fanyuanwen.png"] forState:UIControlStateNormal];
	}
	
	NSInteger changeSize = self._summaryTextView.contentSize.height - self._summaryTextView.frame.size.height;
	[self changeFrame:changeSize];
}

-(void)changeFrame:(NSInteger)changeSize{
//	[UIView beginAnimations:@"" context:nil];
//	[UIView setAnimationDuration:0.5];
	
	if(changeSize == 0){
		if(self._summaryTextView.contentSize.height > self._summaryTextView.frame.size.height){
			changeSize = self._summaryTextView.contentSize.height - self._summaryHeight;
		}
		else{
			changeSize = self._summaryHeight - self._summaryTextView.frame.size.height;
		}
	}
	
	self._summaryTextView.frame = CGRectMake(5, 3, 290, self._summaryTextView.frame.size.height + changeSize);
	self._unfoldBtn.frame = CGRectMake(225, self._unfoldBtn.frame.origin.y + changeSize, 60, 28);
	self._translateBtn.frame = CGRectMake(15, self._translateBtn.frame.origin.y + changeSize, 90, 28);
	// TODO: picListView
	self.picListView.frame = CGRectMake(20, self.picListView.frame.origin.y + changeSize, 260, self.picListView.frame.size.height);
	self._detailsViewTwo.frame = CGRectMake(10, self._detailsViewTwo.frame.origin.y, 300, self._detailsViewTwo.frame.size.height + changeSize);
	self._bottomBackBtn.frame = CGRectMake(25, self._bottomBackBtn.frame.origin.y + changeSize, 270, 43);
	self._detailCommentView.frame = CGRectMake(10, self._detailCommentView.frame.origin.y + changeSize, 300, self._detailCommentView.frame.size.height);
	self.adView.frame = CGRectMake(10, self.adView.frame.origin.y + changeSize, 300, 107);
	self._scrollView.contentSize = CGSizeMake(320, self._scrollView.contentSize.height + changeSize);
	
	if(self._summaryHeight < self._summaryTextView.frame.size.height){
		[self._unfoldBtn setBackgroundImage:[UIImage imageNamed:@"shouqi.png"] forState:UIControlStateNormal];
	}
	else{
		[self._unfoldBtn setBackgroundImage:[UIImage imageNamed:@"zhankai.png"] forState:UIControlStateNormal];
		self._scrollView.contentOffset = CGPointMake(0, 0);
	}
	
//	[UIView commitAnimations];
}

-(void)hideMessage{
	if(self._messageTool != nil){
		[self._messageTool hideMessage];
		self._messageTool = nil;
	}
}

-(void)testMessage{
//	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享给朋友" delegate:self cancelButtonTitle:@"取消" 
//											   destructiveButtonTitle:nil otherButtonTitles:@"新浪微博分享",@"短信分享",nil];
//	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//	[actionSheet showInView:self.view];
//	[actionSheet release];
	
	UIActionSheet *actionSheet;
	Class messageClass = NSClassFromString(@"MFMessageComposeViewController");
	if(messageClass != nil){
		if([messageClass canSendText]){
			actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享给朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博分享",@"短信分享",nil];
		}
		else{
			actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享给朋友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博分享",nil];
		}
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	// 新浪微博分享
	if(buttonIndex == 0){
		ShareController *shareVC = [[ShareController alloc] init];
		shareVC.appInfo = self._app;
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shareVC];
		//[nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_beijing.png"]];
		
		
	//	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_beijing.png"]];
//		imgView.frame = CGRectMake(0, 0, 320, 44);
//		[nav.navigationBar addSubview:imgView];
//		[nav.navigationBar insertSubview:imgView atIndex:0];
//		[imgView release];
		
		
		[self.navigationController presentModalViewController:nav animated:NO];
		[shareVC release];
		[nav release];
		
		[MobClick event:@"分享" label:@"新浪微博"];
	}
	
	else if(buttonIndex == 1){
		
		self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
		if(self.haveNetwork){
			Class messageClass = NSClassFromString(@"MFMessageComposeViewController");
			if(messageClass != nil){
				if([messageClass canSendText]){
					[self showHUD];
				}
			}
			else{
				self._messageTool = [[[MessageTool alloc] initWithView:self.view] autorelease];
				[self._messageTool showNetworkStatus:self.haveNetwork];
				[self performSelector:@selector(hideMessage) withObject:self afterDelay:2];
			}
		}
	}
}

-(void)showHUD{
	self._pageBoundHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	self._pageBoundHUD.labelText = @"正在加载...";
	self._pageBoundHUD.delegate = self;
	[self.view addSubview:self._pageBoundHUD];
	[self._pageBoundHUD showWhileExecuting:@selector(sendsms:) onTarget:self 
								withObject:[NSString stringWithFormat:@"我刚在“限时免费”里下了个iphone应用，名字叫：%@，挺不错的，你也试试吧！http://www.app111.com/m%@ (分享自  @热门应用精选)",self._app._appName,self._app._appID] animated:YES];
}

-(void)sendsms:(NSString *)message{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if(messageClass != nil){
		if([messageClass canSendText]){
			[self performSelectorOnMainThread:@selector(displaySMS:) withObject:message waitUntilDone:YES];
		}
		
		else{
			[self alertWithTitle:nil msg:@"设备没有短信功能"];
		}
	}
	
	else{
		[self alertWithTitle:nil msg:@"ios版本过低，ios4.0以上才支持程序内发送短信"];
	}
}

-(void)displaySMS:(NSString *)message{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.navigationBar.tintColor = [UIColor blackColor];
	picker.body = message;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
	[self._pageBoundHUD removeFromSuperview];
	self._pageBoundHUD = nil;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				didFinishWithResult:(MessageComposeResult)result{
	NSString *msg;
	switch(result){
		case MessageComposeResultSent:
			msg = @"发送成功";
			[self alertWithTitle:nil msg:msg];
			
			[MobClick event:@"分享" label:@"短信"];
			break;
		case MessageComposeResultCancelled:
			msg = @"发送取消";

			break;
		case MessageComposeResultFailed:
			msg = @"发送失败";
			[self alertWithTitle:nil msg:msg];
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void)alertWithTitle:(NSString *)title msg:(NSString *)msg{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil 
										  cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(float)TransAppScore:(float)value{
		int toTen =(int)(value * 10);
		int shangshu = toTen / 10;
		
		float panduan = value - shangshu;
		if(panduan > 0.5){
			return (shangshu + 1) / 2.0;
		}
		else if(panduan < 0.5){
			return shangshu / 2.0;
		}
		else{
			return shangshu / 2.0;
		}
}

- (void)dealloc {

	self.queue = nil;
	self.picqueue = nil;
	
	self.picListView = nil;
	
	self._app = nil;
	self._nextApp = nil;
	self._detailsViewOne = nil;
	self._detailsViewTwo = nil;
	self._detailCommentView = nil;
	self._scrollView = nil;
	self._summaryTextView = nil;
	
	self._unfoldBtn = nil;
	self._translateCacheStr = nil;
	self._pageBoundHUD = nil;
	self._messageTool = nil;
	
	[self._appListDownloader cancelDownload];
	self._appListDownloader.delegate = nil;
	self._appListDownloader = nil;
	
	
	[self._nextDetailsVC._appListDownloader cancelDownload];
	self._nextDetailsVC._appListDownloader.delegate = nil;
	self._nextDetailsVC = nil;
	
	self._iconDownloader.delegate = nil;
	self._iconDownloader = nil;
	
	self.adView = nil;
	[_bottomBackBtn release];
	[_translateBtn release];
    [videoView release];
    
    [super dealloc];
}


@end
