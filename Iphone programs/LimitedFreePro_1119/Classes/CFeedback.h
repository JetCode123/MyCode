//
//  CFeedback.h
//  AppNavForIphone
//
//  Created by 聂 刚 on 11-5-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageTool;
@interface CFeedback : UIViewController<UIWebViewDelegate> {
	UIWebView *webView;
	
	UIView *ui_indicatorView;
	UIActivityIndicatorView *ui_indicator;
	
	BOOL haveNetwork;
	MessageTool *messageView;
	
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic,retain) UIView *ui_indicatorView;
@property (nonatomic,retain) UIActivityIndicatorView *ui_indicator;

@property (nonatomic) BOOL haveNetwork;
@property (nonatomic,retain) MessageTool *messageView;

-(void)webviewNetworkChanged;

@end
