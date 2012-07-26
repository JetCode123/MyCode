//
//  ShareController.h
//  AppNavigator
//
//  Created by Meng Xiangping on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageManipulator.h"
#import "UIImageExtend.h"
#import "MApp.h"
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "AuthController.h"
#import "WeiboNavBar.h"
#import "MobClick.h"
#import "WeiboHelper.h"
#import "MessageTool.h"
//#include "Weibo.h"

#define TAG_SUCCESS 1
#define TAG_FAIL 2

//#ifndef CALLBACK
//#define CALLBACK
//NSString * callbackURL = @"http://www.sina.com.cn";  
//#endif

@interface ShareController : UIViewController <MBProgressHUDDelegate, UITextViewDelegate,UIActionSheetDelegate>{

	BOOL isLoadOver;
	NSTimer *timer;
 @private
  
  MApp *appInfo_;    
  UITextView *textView_;    
  UIImageView *imageLogo_;
  UILabel *labelTextLimit_;
  MBProgressHUD *HUD;
  
    UIButton *btn_UserNumber;
    UIView *container;
    
    MessageTool *messageView;
    
    BOOL isChineseKeyboard;
}

@property (nonatomic) BOOL isLoadOver;

@property (nonatomic, retain) UIImageView *imageLogo;           
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *labelTextLimit;
@property (nonatomic, retain) MApp *appInfo;
@property (nonatomic,retain) UIButton *btn_UserNumber;
@property (nonatomic,retain) UIView *container;
@property (nonatomic,retain) MessageTool *messageView;

- (void) cancel;
- (void) submit: (NSArray *) msgArr;
- (void) toSubmit;
- (IBAction) unBind;

- (void) HUDFinish;
- (void) HUDFail:(NSNumber *) errCode;

- (void) updateTextLimit;
-(void) hideMessage;
-(void) showNetworkStatus;

-(void)judeTheNetworkState;
- (void)keyboardWillShow:(NSNotification *)aNotification;

@end
