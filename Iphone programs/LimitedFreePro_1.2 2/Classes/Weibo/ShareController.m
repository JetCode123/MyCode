//
//  ShareController.m
//  AppNavigator
//
//  Created by Meng Xiangping on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareController.h"
#import <QuartzCore/QuartzCore.h>
#import "Contants.h"
    #import "MobClick.h"

@implementation ShareController

@synthesize isLoadOver;

@synthesize appInfo = appInfo_;
@synthesize textView = textView_;
@synthesize imageLogo = imageLogo_;
@synthesize labelTextLimit = labelTextLimit_;
@synthesize btn_UserNumber;
@synthesize container;
@synthesize messageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    self.appInfo = nil;
    self.imageLogo = nil;
    self.labelTextLimit = nil;
    self.btn_UserNumber = nil;
    self.container = nil;
    self.messageView = nil;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)unBind{
  [[WeiboHelper sharedHelper] unbindAccount];
  
  self.navigationItem.backBarButtonItem = nil;
  AuthController *bindController = [[AuthController alloc] initWithNibName:@"AuthController" bundle:nil];
  [self.navigationController pushViewController:bindController animated:NO];
    [bindController release];
}

- (void)cancel{

  [self.navigationController dismissModalViewControllerAnimated:YES];

}

- (void)toSubmit{
    [self.textView resignFirstResponder];
    if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [self.view.window addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"提交中...";
        [HUD showWhileExecuting:@selector(submit:) onTarget:self 
                     withObject:[NSArray arrayWithObjects:self.textView.text,self.imageLogo.image, nil] animated:YES];
    }else{
        [self showNetworkStatus];
    }
}

- (void)submit:(NSArray *)msgArr{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  if([msgArr count] != 2){
    return;
  }
  
    int status = [[WeiboHelper sharedHelper] uploadImage:[msgArr objectAtIndex:0] withImage:[msgArr objectAtIndex:1]];
  if(status != 0){
       
    [self performSelectorOnMainThread:@selector(HUDFail:) withObject:[NSNumber numberWithInt:status] waitUntilDone:YES];

  }else{
    
    [self performSelectorOnMainThread:@selector(HUDFinish) withObject:nil waitUntilDone:YES];
    
  }
  

    sleep(1);
    [pool release];

}

- (void)HUDFinish{

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.tag = TAG_SUCCESS;
    [HUD setCustomView:imageView];
    HUD.labelText = @"提交成功";
    [HUD updateIndicators];
    [imageView release];
    [MobClick event:@"微博分享成功" label:@"成功发送"];

}

- (void)HUDFail:(NSNumber *)errCode{
    HUD.tag = TAG_FAIL;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong.png"]];
    [HUD setCustomView:imageView];
    [imageView release];
    HUD.mode = MBProgressHUDModeCustomView;
    if(errCode == [NSNumber numberWithInt:-1]){
        HUD.labelText = @"不能重复提交";
		//HUD.labelText = @"提交内容不能为空";
    }else if(errCode == [NSNumber numberWithInt:-3]){
        HUD.labelText = @"无网络连接";
    }else{
        HUD.labelText = @"提交失败";
    }
	
	if([self.textView.text isEqualToString:@""]){
		HUD.labelText = @"提交内容不能为空";
	}
    [HUD updateIndicators];
}

- (void)hudWasHidden:(MBProgressHUD *)hud{

    [HUD removeFromSuperview];
    [HUD release];
    if(hud.tag != TAG_FAIL){
        [self cancel];
    }
}

#pragma mark - View lifecycle
- (void)viewDidAppear:(BOOL)animated{
    
  UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 30)];
  [btnCancel setBackgroundImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
  [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
  [btnCancel setTitle:@"取 消" forState:UIControlStateNormal];
  btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
  
  UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 30)];
  [btnSubmit setBackgroundImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
  [btnSubmit addTarget:self action:@selector(toSubmit) forControlEvents:UIControlEventTouchUpInside];
  [btnSubmit setTitle:@"提 交" forState:UIControlStateNormal];
  btnSubmit.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnSubmit] autorelease];
  [btnSubmit release];
    

//    //如果没有绑定帐号
//    if([WeiboHelper sharedHelper].accessToken == nil ||
//       [WeiboHelper sharedHelper].accessSecret == nil){
//        
//        self.navigationItem.backBarButtonItem = nil;
//        AuthController *bindController = [[AuthController alloc] initWithNibName:@"AuthController" bundle:nil];
//        [self.navigationController pushViewController:bindController animated:NO];
//        [bindController release];
//        return;
//    }
//    //验证 Access_Token 是否过期
//    else{
//        if([[WeiboHelper sharedHelper] requestUserInfo].userID == nil){
//            //如果Access_Token 过期， 重新申请
//            [[WeiboHelper sharedHelper] requestAccessToken];
//            [[WeiboHelper sharedHelper] requestUserInfo];
//        }
//    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
        [self.textView resignFirstResponder];
        self.messageView = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
        [self.messageView showLoading:@"加载数据 . . ."];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(judeTheNetworkState) userInfo:nil repeats:NO];
       
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *inv = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getUserName) object:nil];
        [queue addOperation:inv];
        
        [inv release];
        [queue release];
    }else{
        [self showNetworkStatus];
    }
}

-(void)judeTheNetworkState{
	if(self.isLoadOver == YES){
		[timer invalidate];
	}
	
	else{
		for(UIView *_v in self.messageView.subviews){
			if(_v){
				[_v removeFromSuperview];
				_v = nil;
			}
		}
		
		[self.messageView showLoading:@"连接超时,请重试"];
		[self performSelector:@selector(hideMessage) withObject:nil afterDelay:3];
	}
}

-(void) getUserName{
    //如果没有绑定帐号
    if([WeiboHelper sharedHelper].accessToken == nil ||
       [WeiboHelper sharedHelper].accessSecret == nil){
        [self performSelectorOnMainThread:@selector(bindUser) withObject:nil waitUntilDone:YES];
        return;
    }
    if([[WeiboHelper sharedHelper] requestUserInfo].userID == nil){
        //如果Access_Token 过期， 重新申请
        [[WeiboHelper sharedHelper] requestAccessToken];
        [[WeiboHelper sharedHelper] requestUserInfo];
    }
    
    NSString *name = [[WeiboHelper sharedHelper] requestUserInfo].screenName;
	
	
    [self performSelectorOnMainThread:@selector(showName:) withObject:name waitUntilDone:YES];
}

-(void)bindUser{
    [self hideMessage];
    self.navigationItem.backBarButtonItem = nil;
	
	if(self.navigationController.viewControllers.count == 1){
		AuthController *bindController = [[AuthController alloc] initWithNibName:@"AuthController" bundle:nil];
		[self.navigationController pushViewController:bindController animated:NO];
		[bindController release];
	}

}

-(void) showName:(NSString *)name{
    [self.btn_UserNumber setTitle:name forState:UIControlStateNormal];
    [self.container removeFromSuperview];
    [self.view addSubview:self.btn_UserNumber];
    [self updateTextLimit];
    [self.textView becomeFirstResponder];
    [self hideMessage];
	
	self.isLoadOver = YES;
}
-(void) networkChange{
    [self showNetworkStatus];
    if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *inv = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getUserName) object:nil];
        [queue addOperation:inv];
        
        [inv release];
        [queue release];
    }
}
-(void) showNetworkStatus{
    if (!self.messageView) {
        BOOL haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
        self.messageView = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
        [self.messageView showNetworkStatus:haveNetwork];
        [self performSelector:@selector(hideMessage) withObject:self afterDelay:2];
    }
}

-(void) hideMessage{
    if (self.messageView != nil) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification{

    NSLog(@"键盘显示");
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *keyboard = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
    CGSize keyboardSize = [keyboard CGRectValue].size;
    
    NSValue *animation = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animation getValue:&animationDuration];
    
    CGRect userNumberRect = self.btn_UserNumber.frame;
    CGRect labelTextLimitRect = self.labelTextLimit.frame;
    CGRect textViewRect = self.textView.frame;
    
//    TOOD:根据键盘的高度来判断上面视图的显示。
    if(keyboardSize.height == 252){
        
        //阻止多次调用这个方法 改变各个视图的高度值。。。        
        if(userNumberRect.origin.y == 104)
            return;
        
        isChineseKeyboard = YES;
    
        [UIView beginAnimations:@"放大键盘" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        userNumberRect.origin.y -= 36;
        labelTextLimitRect.origin.y -= 36;
        textViewRect.size.height -= 36;

//        NSLog(@"yyyyyy = %f",userNumberRect.origin.y);                        104 , 114 , 99
//        NSLog(@"label = %f",labelTextLimitRect.origin.y);
//        NSLog(@"textView = %f",textViewRect.size.height);
        
        [self.btn_UserNumber setFrame:userNumberRect];
        [self.textView setFrame:textViewRect];
        [self.labelTextLimit setFrame:labelTextLimitRect];
        
        [UIView commitAnimations];
    }
    
    if(keyboardSize.height == 216){
        if(isChineseKeyboard){
            isChineseKeyboard = NO;
            
            [UIView beginAnimations:@"收缩键盘那" context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            userNumberRect.origin.y += 36;
            labelTextLimitRect.origin.y += 36;
            textViewRect.size.height += 36;
            
            [self.btn_UserNumber setFrame:userNumberRect];
            [self.textView setFrame:textViewRect];
            [self.labelTextLimit setFrame:labelTextLimitRect];
            
            [UIView commitAnimations];
        }
    }
}

- (void)viewDidLoad
{
  [super viewDidLoad];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:NETWORK_NOTIFICATION object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
//	UIImage *img = [UIImage imageNamed: @"weibotitle.png"];
//  UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//  [imageView setFrame:self.navigationController.navigationBar.bounds];
//  [imageView setContentMode:UIViewContentModeScaleToFill];
//  [self.navigationController.navigationBar addSubview:imageView];
//  [imageView release];
    
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_beijing.png"]];
	imgView.frame = self.navigationController.navigationBar.bounds;
	[imgView setContentMode:UIViewContentModeScaleToFill];
	
	[self.navigationController.navigationBar addSubview:imgView];
	[imgView release];
	
    self.textView = [[[UITextView alloc] init]autorelease];
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.frame = CGRectMake(55, 5, 255, 135);
  self.textView.delegate = self; 
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:self.textView];
    
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textBg.png"]];
    
    UIImage *logoImage;
    logoImage = [ImageManipulator makeRoundCornerImage:[ImageCache loadFromCacheWithID:self.appInfo._appWifiLogoPath andDir:DIR_LIST] :26 :26];
    if(logoImage == nil){
        logoImage = [ImageManipulator makeRoundCornerImage:[ImageCache loadFromCacheWithID:self.appInfo._appLogoPath andDir:DIR_LIST] :13 :13];
    }
    
    self.imageLogo = [[UIImageView new] autorelease];
    self.imageLogo.frame = CGRectMake(5, 5, 45, 45);
    self.imageLogo.image = [logoImage imageWithShadow];
    [logoImage release];
    [self.view addSubview:self.imageLogo];
  
    
  UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
  labelTitle.text = @"分享到新浪微博";
  labelTitle.backgroundColor = [UIColor clearColor];
  labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:18];
  labelTitle.textAlignment = UITextAlignmentCenter;
  self.navigationItem.titleView = labelTitle;
  [labelTitle release];

//  self.textView.text = [NSString stringWithFormat:@"我刚在 “限时免费” 里下载了个iphone应用, 名字叫:%@,挺不错的，你也试试吧！%@ (分享自 @热门应用精选)",
//                        self.appInfo._appName,self.appInfo._appSourceURL];
	
  
	self.textView.text = [NSString stringWithFormat:@"我刚在 “限时免费” 里下载了个iphone应用, 名字叫:%@,挺不错的，你也试试吧！%@ (分享自 @热门应用精选)",
						  self.appInfo._appName,[NSString stringWithFormat:@"http://www.app111.com/info/%@",self.appInfo._appID]];
    
	self.btn_UserNumber = [[UIButton new] autorelease];
    [self.btn_UserNumber setBackgroundImage:[UIImage imageNamed:@"userNumber.png"] forState:UIControlStateNormal];
    self.btn_UserNumber.titleLabel.font  = [UIFont systemFontOfSize:13];
    self.btn_UserNumber.titleLabel.textColor = [UIColor whiteColor];
    self.btn_UserNumber.frame = CGRectMake(2, 140, 200, 62);
    [self.btn_UserNumber setTitleEdgeInsets:UIEdgeInsetsMake(5, 3, 12, 25)];
    [self.btn_UserNumber addTarget:self action:@selector(changeWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    self.labelTextLimit = [[[UILabel alloc] init] autorelease];
    self.labelTextLimit.frame = CGRectMake(205, 150, 115, 16);
    self.labelTextLimit.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.labelTextLimit];
}
-(void) changeWeibo{
    UIActionSheet *ui_actionsheet=[[UIActionSheet alloc]initWithTitle:@"帐号管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"绑定新帐号",nil];
	ui_actionsheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
	[ui_actionsheet showInView:self.view];
	[ui_actionsheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self unBind];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//	NSLog(@"text = %@",text);
//	NSLog(@"text.length = %d",text.length);
//	
//	NSLog(@"range-length = %d",range.length);
//	
//	NSLog(@"length = %d\n\n",textView.text.length);
//	NSLog(@"textView.text.length = %d",textView.text.length);
	
    [self updateTextLimit];
    
    if ([text length] < 1) {
		
		if(textView.text.length == 0){
			self.labelTextLimit.text = [NSString stringWithFormat:@"您还可以输入 %i 字",140];
		}
		
		else if(textView.text.length != 0){
			self.labelTextLimit.text = [NSString stringWithFormat:@"您还可以输入 %i 字",140 - textView.text.length + 1];
		}
        return YES;
    }
	
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 140) ? NO : YES;
}

-(void)textViewDidChange:(UITextView *)textView{
	self.labelTextLimit.text = [NSString stringWithFormat:@"您还可以输入 %i 字",140 - textView.text.length];
}

- (void)updateTextLimit{
    
  NSInteger remainChars = 140 - [self.textView.text length];
  if(remainChars <= 0) remainChars = 0;
  self.labelTextLimit.text = [NSString stringWithFormat:@"您还可以输入 %i 字",remainChars];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_beijing.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
