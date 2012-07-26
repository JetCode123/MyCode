//
//  AppListCellView.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppListViewController;
@class AppListBasedCell;

@class AppListCell;

@interface AppListCellView : UIView {
	AppListCell *_contentCell;
	
	
	//AppListBasedCell *_contentCell;
	UILabel *_detailLabel;
	UIImageView *_detailImageView;
	
	AppListViewController *_appListVC;
	CGPoint originalPoint;
	NSIndexPath *_indexPath;
	UITableView *_tableView;
	AppListCell *_basedCell;
	
}
 
@property (nonatomic,retain) AppListCell *_contentCell;

//@property (nonatomic,retain) AppListBasedCell *_contentCell;
@property (nonatomic,retain) AppListViewController *_appListVC;
@property (nonatomic,retain) UILabel *_detailLabel;
@property (nonatomic,retain) UIImageView *_detailImageView;
@property (nonatomic,retain) NSIndexPath *_indexPath;
@property (nonatomic,retain) UITableView *_tableView;
@property (nonatomic,retain) AppListCell *_basedCell;


-(id)initWithFrame:(CGRect)frame andCell:(AppListCell *)cell;

+(NSString *)stringWithDate:(NSDate *)date;

-(float)getAppScore:(float)value;

@end
