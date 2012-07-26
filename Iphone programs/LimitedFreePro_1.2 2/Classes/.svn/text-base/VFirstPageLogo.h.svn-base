//
//  VFirstPageLogo.h
//  限时免费_me
//
//  Created by lujiaolong on 11-9-13.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAd.h"
#import "MApp.h"

@class AppListViewController;

@interface VFirstPageLogo : UIView {
	UIButton *_redirectBtn;
//	MAd *_mad;
	
	MApp *_mad;
	UIActivityIndicatorView *_activityView;
	AppListViewController *_appListVC;
	UIImageView *_bottomImageView;
	
	UIImageView *_defaulteImageView;
	NSString *_networkType;
	UIImageView *xiushiImgView;
	UILabel *nameLabel;
}

@property (nonatomic,retain) UIButton *_redirectBtn;
@property (nonatomic,retain) MApp *_mad;
@property (nonatomic,retain) UIActivityIndicatorView *_activityView;
@property (nonatomic,assign) AppListViewController *_appListVC;
@property (nonatomic,copy) NSString *_networkType;
@property (nonatomic,retain) UIImageView *xiushiImgView;
@property (nonatomic,retain) UILabel *nameLabel;

-(void)bindItem;

@end
