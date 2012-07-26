//
//  VAD.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-2.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDetailsViewController;

@interface VAD : UIView {
	AppDetailsViewController *appDetailController;
	UILabel *infoLabel;
	NSMutableArray *data;
	NSInteger totalCount;
}

@property (nonatomic,assign) AppDetailsViewController *appDetailController;
@property (nonatomic,retain) UILabel *infoLabel;
@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic) NSInteger totalCount;

-(void)asynInit;
-(void)addImageView;
-(void)loadAd;
@end
