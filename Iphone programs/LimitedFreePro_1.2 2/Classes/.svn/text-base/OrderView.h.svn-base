//
//  OrderView.h
//  TimeLimitFree
//
//  Created by lu jiaolong on 11-8-28.
//  Copyright 2011 sensosourcing Inc Beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface OrderView : UIView {
	UIButton *_newBtn;
	UIButton *_hotBtn;
	UIButton *_scoreBtn;
	UIButton *_priceBtn;
	
	UILabel *_newLabel;
	UILabel *_hotLabel;
	UILabel *_scoreLabel;
	UILabel *_priceLabel;
	
	UIButton *_infoBtn;
	UILabel *feedBackLabel;
	
	RootViewController *_rootVC;
	NSDictionary *fenleiDict;
	
	NSInteger _typeID;
}

@property (nonatomic,retain) RootViewController *_rootVC;
@property (nonatomic) NSInteger _typeID;

-(void)hotAction;
-(void)newAction;
-(void)scoreAction;
-(void)priceAction;
-(void)feedAction;

-(void)presentInfo;

-(void)reloadMainViewController:(NSString *)orderStr;
-(void)largeAndSmallWithBtn:(UIButton *)btn andLabel:(UILabel *)label;

-(void)largeForBtn:(UIButton *)btn andLabel:(UILabel *)label;
-(void)smallForBtn:(UIButton *)btn andLabel:(UILabel *)label;
@end
