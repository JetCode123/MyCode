//
//  AppPicListView.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MApp.h"

@class AppDetailsViewController;

@interface AppPicListView : UIView {
	MApp *application;
	NSMutableDictionary *imageDict;
	
	AppDetailsViewController *detailController;
}

@property (nonatomic,retain) MApp *application;
@property (nonatomic,assign) AppDetailsViewController *detailController;
@property (nonatomic,retain) NSMutableDictionary *imageDict;

-(void)showImages;
@end
