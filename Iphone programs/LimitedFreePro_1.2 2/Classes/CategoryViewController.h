//
//  CategoryViewController.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"

@interface CategoryViewController : UIViewController <UIScrollViewDelegate>{
	
	UIScrollView *_scrollView;
	NSMutableArray *_categoryData;
	
	NSMutableArray *_cateItemList;
	
	BOOL isReload;
}

@property (nonatomic,retain) NSMutableArray *_categoryData;
@property (nonatomic,retain) UIScrollView *_scrollView;
@property (nonatomic,retain) NSMutableArray *_cateItemList;
@property (nonatomic) BOOL isReload;

-(void)showData;
-(void)setNavigationItem;
-(void)pop;

@end
