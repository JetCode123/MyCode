//
//  AuthController.h
//  AppNavigator
//
//  Created by Meng Xiangping on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboHelper.h"
#import "MBProgressHUD.h"
#import "MessageTool.h"

@interface AuthController : UIViewController <UIWebViewDelegate, MBProgressHUDDelegate> {
    
	BOOL haveNetwork;
	BOOL loadOver;
	
  @private
   UIWebView *webView_;
   MBProgressHUD *hud_;
    MessageTool *messageView;
}

@property (nonatomic) BOOL haveNetwork;
@property (nonatomic) BOOL loadOver;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) MBProgressHUD *hud;
@property(nonatomic,retain) MessageTool *messageView;

-(void) hideMessage;

@end
