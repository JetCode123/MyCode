//
//  AppExampleImageController.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPicView.h"

@interface AppExampleImageController : UIViewController <UIScrollViewDelegate>{
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	NSMutableArray *exampleImageArray;
	NSInteger numberPages;
	
	NSMutableArray *imageViews;
	NSMutableDictionary *imageDict;
	
	CGPoint imagePoint;
	NSInteger currentPage;
	AppPicView *listView;
}

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) NSMutableArray *exampleImageArray;

@property (nonatomic) NSInteger numberPages;
@property (nonatomic,retain) NSMutableArray *imageViews;
@property (nonatomic,retain) NSMutableDictionary *imageDict;

@property (nonatomic) CGPoint imagePoint;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic,assign) AppPicView *listView;

-(void)click;
-(void)addClick;
-(void)removeSelf;

@end
