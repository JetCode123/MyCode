//
//  PlayerViewController.m
//  LimitedFreePro
//
//  Created by lu jiaolong on 11-10-31.
//  Copyright (c) 2011年 SequelMedia. All rights reserved.
//

// 1.dns出错，提示超时。

#import "PlayerViewController.h"
#import "Contants.h"

#define kTimeInterval 10

@interface PlayerViewController(PrivateMethods)
- (void)moviePlayerLoadStateChanged:(NSNotification *)notification;
- (void)moviePlayerPlayBackDidFinish:(NSNotification *)notification;
- (void)dismiss;

@end

@implementation PlayerViewController
@synthesize videoURL;
@synthesize playerVC;
@synthesize beginDate,endDate;
@synthesize isLoadOver; 
@synthesize haveNetwork;

@synthesize mBar;

- (id)init{
    if(self = [super init]){
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.wantsFullScreenLayout = YES; 
    
	
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.haveNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:Key_HaveNetwork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
//  添加视频时间可知的通知

	UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
	bar.barStyle = UIBarStyleBlackOpaque;
	self.mBar = bar;
	[self.view addSubview:self.mBar];
	[bar release];
	
//	UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
//	black.backgroundColor  = [UIColor blackColor];
//	[self.view addSubview:black];
//	[black release];
}


- (void)judgeTheLoadStatus{
    if(self.isLoadOver){
        [timer invalidate];
    }
    else
    {
        MPMoviePlayerController *mp  = self.playerVC.moviePlayer;
        
        NSLog(@"mp.加载状态 = %d",[mp loadState]);
        NSLog(@"mp.播放状态 = %d",[mp playbackState]);
        
        if(mp && ([mp playbackState] == MPMoviePlaybackStatePlaying || [mp playbackState] == MPMoviePlaybackStateStopped)){
            [mp stop];
            mp = nil;
        }
        
        else if([mp loadState] == MPMovieLoadStateUnknown){
            [mp stop];
            mp = nil;
        }
        
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;

        if(self.haveNetwork)
        {
            UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            
            if(interfaceOrientation == UIInterfaceOrientationPortrait){
    
                errorLabel.center = CGPointMake(160, 240);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
                errorLabel.center = CGPointMake(240, 160);
            }
            
            errorLabel.tag = 100;
            errorLabel.backgroundColor = [UIColor clearColor];
            errorLabel.textAlignment = UITextAlignmentCenter;
            errorLabel.font = [UIFont boldSystemFontOfSize:16.f];
            
            errorLabel.textColor = [UIColor whiteColor];
            errorLabel.text = @"加载视频超时";
            [self.view addSubview:errorLabel];
            [errorLabel release];
        }

        /*
        else 
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            
            if(interfaceOrientation == UIInterfaceOrientationPortrait){
                label.center = CGPointMake(160, 240);
            }
            else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
                label.center = CGPointMake(240, 160);
            }
            
            label.tag = 200;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:16.f];
            
            label.textColor = [UIColor whiteColor];
            label.text = @"网络连接已断开";
            [self.view addSubview:label];
            [label release];
        }
        */
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    }    
}   

- (void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)readyPlayer {
    
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
    self.playerVC = moviePlayerVC;
    [moviePlayerVC release];
    
    MPMoviePlayerController *moviePlayer = [self.playerVC moviePlayer];
	moviePlayer.view.backgroundColor = [UIColor clearColor];
	
    if([moviePlayer respondsToSelector:@selector(loadState)]){
        [moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
        [moviePlayer setFullscreen:YES];
        
        [moviePlayer prepareToPlay]; 
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    }

    else{
        [moviePlayer play];
    }
    
    [self.view addSubview:self.playerVC.view];
   	
    timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(judgeTheLoadStatus) userInfo:nil repeats:NO];
 
    self.beginDate = [NSDate date];
}
 

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification{
    self.endDate = [NSDate date];
    
    NSTimeInterval timeInterval = [self.endDate timeIntervalSinceDate:self.beginDate];
    NSLog(@"From unknow to ok,the time interval is %f",timeInterval);
    
    MPMoviePlayerController *_mp = [self.playerVC moviePlayer];
    NSLog(@"加载状态变化\n");
    
    if([_mp loadState] != MPMovieLoadStateUnknown){
//        [_mp play];

        self.isLoadOver = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    }
  
}

- (void)moviePlayerPlayBackDidFinish:(NSNotification *)notification{
    NSLog(@"播放完毕");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        [self.playerVC.moviePlayer stop];
        self.playerVC.moviePlayer.initialPlaybackTime = -1;
        self.playerVC = nil;
				
		[self dismissModalViewControllerAnimated:YES];
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
    UILabel *errorLabel = (UILabel *)[self.view viewWithTag:100];
    if(errorLabel){
        if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            errorLabel.center = CGPointMake(240, 160);
        else if(interfaceOrientation == UIInterfaceOrientationPortrait)
            errorLabel.center = CGPointMake(160, 240);
    }

    /*
    UILabel *label = (UILabel *)[self.view viewWithTag:200];
    if(label){
        if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
            label.center = CGPointMake(240, 160);
        else if(interfaceOrientation == UIInterfaceOrientationPortrait)
            label.center = CGPointMake(160, 240);
    } */
    
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;    
}

- (void)dealloc {
    [videoURL release];
    [playerVC release];
    
    [beginDate release];
    [endDate release];
    
	[mBar release];
	
    [super dealloc];
}
@end