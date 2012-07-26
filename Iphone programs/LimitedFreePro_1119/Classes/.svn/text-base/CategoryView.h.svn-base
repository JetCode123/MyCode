//
//  CategoryView.h
//  TimeLimitFree
//
//  Created by lu jiaolong on 11-8-29.
//  Copyright 2011 sensosourcing Inc Beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCategory.h"

@class CategoryViewController;
@class RootViewController;

@interface CategoryView : UIView {
	UIImageView *_logoImgView;
	UILabel *_nameLabel;
	MCategory *_currentCategory;
	
	NSInteger lastTouchX;
	NSInteger lastTouchY;
	NSInteger orderIndex;
	
	NSString *_type;
	CategoryViewController *_cateVC;
	
	UINavigationController *_navCtrl;
	
	RootViewController *rootVC;
}

@property (nonatomic,retain) UIImageView *_logoImgView;
@property (nonatomic,retain) UILabel *_nameLabel;
@property (nonatomic,retain) MCategory *_currentCategory;
@property (nonatomic) NSInteger orderIndex;
@property (nonatomic,retain) NSString *_type;
@property (nonatomic,retain) CategoryViewController *_cateVC;

-(void)bindItem;
-(void)showBgColor;
-(void)hideBgColor;

@end
