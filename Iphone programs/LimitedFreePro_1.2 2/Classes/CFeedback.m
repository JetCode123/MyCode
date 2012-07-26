    //
//  CFeedback.m
//  AppNavForIphone
//
//  Created by 聂 刚 on 11-5-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CFeedback.h"
#import "Contants.h"
#import "MessageTool.h"


@interface CFeedback(private)
-(void)showMessage;
-(void)hideMessage;
@end

@implementation CFeedback

@synthesize webView;
@synthesize ui_indicatorView;
@synthesize ui_indicator;
@synthesize haveNetwork;

@synthesize messageView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
- (void)viewWillAppear:(BOOL)animated {
	
	//[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_beijing.png"]];
    [super viewWillAppear:animated];


    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    labelTitle.text = @"意见反馈";
    labelTitle.font = [UIFont boldSystemFontOfSize:21];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = labelTitle;
    [labelTitle release];
}

-(void) viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

-(void)showMessage{
	if(self.messageView == nil){
		self.messageView = [[MessageTool alloc] initWithView:self.webView];
		CGPoint pt = self.messageView.center;
		
		pt.y = 180;
		pt.x = 160;
		[self.messageView setCenter:pt];
		[self.messageView release];
		
		[self.messageView showNetworkStatus:self.haveNetwork];
		[self performSelector:@selector(hideMessage) withObject:nil afterDelay:2];
	}
}

-(void)hideMessage{
	if(self.messageView != nil){
		[self.messageView hideMessage];
		self.messageView = nil; 
		
		[self performSelector:@selector(close) withObject:nil afterDelay:0.3];
	}
}

-(void)webviewNetworkChanged{
	if([[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork]){
		self.haveNetwork = YES;
	}
	
	else{
		self.haveNetwork = NO;
	}
	[self showMessage];
}

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_beijing.png"]];
	imgView.frame = self.navigationController.navigationBar.bounds;
	[imgView setContentMode:UIViewContentModeScaleToFill];
	
	[self.navigationController.navigationBar addSubview:imgView];
	[imgView release];
    
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:modalViewIsOn];
	
	self.navigationItem.title = @"意见反馈";
    
    
	
	self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webviewNetworkChanged) name:NETWORK_NOTIFICATION object:nil];
	
	UIButton *ui_btnRight=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 30)];
	ui_btnRight.backgroundColor=[UIColor clearColor];
	ui_btnRight.titleLabel.font=[UIFont boldSystemFontOfSize:14];
	[ui_btnRight setBackgroundImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
	[ui_btnRight setTitle:@"返 回" forState:UIControlStateNormal];
	[ui_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[ui_btnRight addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *baritems=[[UIBarButtonItem alloc]initWithCustomView:ui_btnRight];
	
	self.navigationItem.rightBarButtonItem=baritems;
	[ui_btnRight release];
	[baritems release];
	
	
	self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+30, 
																self.view.frame.size.height - 44)] autorelease];
	
	[self.view addSubview:self.webView];
	[self.webView loadRequest:[NSURLRequest requestWithURL:
							   [NSURL URLWithString:@"http://adshow.it168.com/ipad/xianmianzhuanyeban.html"]
											   cachePolicy:NSURLRequestReloadIgnoringCacheData
										   timeoutInterval:10]];
	self.webView.delegate = self;
}

-(void)removeLoadView{
	[self.ui_indicator removeFromSuperview];
	self.ui_indicator=nil;
	[self.ui_indicatorView removeFromSuperview];
	self.ui_indicatorView=nil;
}
-(void)buildLoadView{
	self.ui_indicatorView = [[[UIView alloc] init] autorelease];
	self.ui_indicatorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	self.ui_indicatorView.backgroundColor=[UIColor lightGrayColor];
	self.ui_indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
	self.ui_indicator.center = CGPointMake(self.ui_indicatorView.frame.size.width / 2
										   , self.ui_indicatorView.frame.size.height / 2 - 20);
	[self.ui_indicatorView addSubview:self.ui_indicator];
	[self.ui_indicator startAnimating];
	[self.view addSubview:self.ui_indicatorView];
}

#pragma mark webView Delegate.
-(void) webViewDidStartLoad:(UIWebView *)webView{
	if(self.haveNetwork){
		[self buildLoadView];
	}
	else{
		[self showMessage];
	}
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
	[self removeLoadView];
}

- (void) close{
	[self dismissModalViewControllerAnimated:YES];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:modalViewIsOn];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.webView = nil;    
	self.ui_indicator=nil;
	self.ui_indicatorView=nil;
    [super dealloc];
}


@end
