//
//  AuthController.m
//  AppNavigator
//
//  Created by Meng Xiangping on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthController.h"
#import "Contants.h"


@implementation AuthController

@synthesize webView = webView_;
@synthesize hud = hud_;
@synthesize messageView;

@synthesize haveNetwork;

@synthesize loadOver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
  self.webView = nil;
  self.hud = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)cancel{
  
  [self.navigationController dismissModalViewControllerAnimated:YES];
  
}



#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
  UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 30)];
  [btnCancel setBackgroundImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
  [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
  [btnCancel setTitle:@"取 消" forState:UIControlStateNormal];
  btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
  [btnCancel release];
  
  UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
  labelTitle.text = @"绑定新浪微博帐号";
    labelTitle.font = [UIFont boldSystemFontOfSize:18];
  labelTitle.backgroundColor = [UIColor clearColor];
  labelTitle.textColor = [UIColor whiteColor];
  labelTitle.textAlignment = UITextAlignmentCenter;
  self.navigationItem.titleView = labelTitle;
  [labelTitle release];
	

	
	
}
-(void)viewDidAppear:(BOOL)animated{
	
		[[WeiboHelper sharedHelper] callbackRequestToken];  
		NSString *url = [NSString stringWithFormat:@"http://api.t.sina.com.cn/oauth/authorize?oauth_token=%@",
						 [WeiboHelper sharedHelper].oauthToken];
		
		self.webView.scalesPageToFit = YES;
		[self.webView loadRequest:
		 [NSURLRequest requestWithURL:
		  [NSURL URLWithString:url]]];

}

- (void)viewDidLoad
{  
  [super viewDidLoad];
	
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_beijing.png"]];

	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_beijing.png"]];
	imgView.frame = self.navigationController.navigationBar.bounds;
	[imgView setContentMode:UIViewContentModeScaleToFill];
	
	[self.navigationController.navigationBar addSubview:imgView];
	//[self.navigationController.navigationBar insertSubview:imgView	atIndex:0];
	[imgView release];
	
    if(![[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
        self.messageView = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
        [self.messageView showNetworkStatus:NO];
        [self performSelector:@selector(hideMessage) withObject:self afterDelay:2];
        return;
    }
	
	self.messageView = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
	[self.messageView showLoading:@"载入网页 . . ."];
	
	if(self.navigationController.viewControllers.count <= 2){
		
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:NETWORK_NOTIFICATION object:nil];
}


-(void)networkChange{
	if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
		self.haveNetwork = YES;
		
		self.messageView = [[[MessageTool alloc] initWithView:self.navigationController.view] autorelease];
		[self.messageView showNetworkStatus:YES];
		
		[self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
		 
		if(self.loadOver == NO){
			[[WeiboHelper sharedHelper] callbackRequestToken];  
			NSString *url = [NSString stringWithFormat:@"http://api.t.sina.com.cn/oauth/authorize?oauth_token=%@",
							 [WeiboHelper sharedHelper].oauthToken];
			
			self.webView.scalesPageToFit = YES;
			[self.webView loadRequest:
			 [NSURLRequest requestWithURL:
			  [NSURL URLWithString:url]]];
		}
	}
	else{
		self.haveNetwork = NO;
	}
	
}

-(void) hideMessage{
    if (self.messageView != nil) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	
	self.loadOver = YES;
	
    [self hideMessage];
  if(self.hud != nil){
    [self.hud hide:YES];
  }

//  NSRegularExpression *regex
//  NSString *js = @"var reg = \^[0-9]+$\";
  
//  NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
//  NSString *str = [html stringByMatching:@"^[0-9]+$"];
//  NSArray *arr = [html componentsMatchedByRegex:@"^[0-9]+$"];
//  NSLog(@"arr len %@",str);
//  NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]+$"];
//  NSLog(@"%@",html);
//  NSLog(@"%@",[webView )
  NSString *authID = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"verifier\")[0].innerText"];


  if([authID length] > 0){    
  
  [WeiboHelper sharedHelper].userPin = authID;
  [[NSUserDefaults standardUserDefaults] setObject:authID forKey:kUserPin];
  [[WeiboHelper sharedHelper] requestAccessToken];
  [[WeiboHelper sharedHelper] requestUserInfo];

  if([WeiboHelper sharedHelper].userID != nil){

    [self.navigationController popViewControllerAnimated:YES];

  }
    
  }
  
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
  
//  if(self.hud == nil){
//    
//    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
//    self.hud.delegate = self;
//    self.hud.labelText = @"加载中...";
//    [self.view addSubview:self.hud];
//    [self.hud show:YES];
//    
//  }
  
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
  
  [self.hud removeFromSuperview];
  self.hud = nil;
  
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
