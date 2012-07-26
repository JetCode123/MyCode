//
//  AppListCell.h
//  LimitedFreePro
//
//  Created by lujiaolong on 11-11-10.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MApp.h"
#import "AppListCellView.h"

@interface AppListCell : UITableViewCell {
	UIImageView *_iconImgView;
	UIImageView *_iconMaskImgView;
	MApp *_app;
	NSInteger _orderIndex;
	
	UIView *_cellContentView;
}

@property (nonatomic,retain) UIImageView *_iconImgView;
@property (nonatomic,retain) UIImageView *_iconMaskImgView;

@property (nonatomic,retain) MApp  *_app;
@property (nonatomic) NSInteger _orderIndex;

@property (nonatomic,retain) UIView *_cellContentView;
@end
