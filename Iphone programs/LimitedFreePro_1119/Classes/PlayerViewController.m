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
#import "GradientView.h"

#define kTimeInterval 15

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

@synthesize gradientV;

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
    
//    黑框
    GradientView *mGradientV = [[GradientView alloc] initWithFrame:CGRectMake(0, 20, 320, 43)];
    
    self.gradientV = mGradientV;
    [self.view addSubview:self.gradientV];
    [mGradientV release];
    
//    黑框底线
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, 320, 1)];

    bottomView.backgroundColor = [UIColor colorWithRed:0.094 green:0.094 blue:0.094 alpha:1];
    bottomView.tag = 333;
    [self.view addSubview:bottomView];
    [bottomView release];

//  加载标签  
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    loadingLabel.tag = 111;
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.font = [UIFont boldSystemFontOfSize:14.f];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"正在载入...";
    loadingLabel.center = CGPointMake(145, 22);

    [self.gradientV addSubview:loadingLabel];
    [loadingLabel release];
    
//  菊花控件
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicatorView.center = CGPointMake(200, 22);
    
    indicatorView.tag = 222;
    [self.gradientV addSubview:indicatorView];
    [indicatorView startAnimating];
    [indicatorView release];
    
//    Done Btn 
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.frame = CGRectMake(0, 0, 48, 28);
    doneBtn.center = CGPointMake(5 + 24, 22);
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"Done.png"] forState:UIControlStateNormal];
    doneBtn.tag = 444;
    [self.gradientV addSubview:doneBtn];
}

- (void)doneAction:(id)sender{
    MPMoviePlayerController *moviePlayer = self.playerVC.moviePlayer;
    if(moviePlayer){
        if([moviePlayer playbackState] == MPMoviePlaybackStatePlaying || [moviePlayer playbackState] == MPMoviePlaybackStateStopped){
            [moviePlayer stop];
            moviePlayer = nil;
        }
        
        else if([moviePlayer loadState] == MPMovieLoadStateUnknown){
            [moviePlayer stop];
            moviePlayer = nil;
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
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
            
            UILabel *loadingLabel = (UILabel *)[self.gradientV viewWithTag:111];
            loadingLabel.text = @"";
            
            UIActivityIndicatorView *iv = (UIActivityIndicatorView *)[self.gradientV viewWithTag:222];
            [iv stopAnimating];
        }

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
        [_mp play];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    UILabel *errorLabel = (UILabel *)[self.view viewWithTag:100];
    
    UILabel *loadingLabel = (UILabel *)[self.gradientV viewWithTag:111];
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[self.gradientV viewWithTag:222];
    
    UIView *bottomView = (UIView *)[self.view viewWithTag:333];
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
      
        self.gradientV.frame = CGRectMake(0, 20, 480, 43);
        bottomView.frame = CGRectMake(0, 63, 480, 1);
        
        if(errorLabel){
            errorLabel.center = CGPointMake(240, 160);
        }

        if(loadingLabel){
            loadingLabel.center = CGPointMake(145 * 480 / 320, 22);
        }
        if(indicatorView){
            indicatorView.center = CGPointMake(200 * 480 / 320, 22);
        }
    }
    
    else if(interfaceOrientation == UIInterfaceOrientationPortrait){
        
        self.gradientV.frame = CGRectMake(0, 20, 320, 43);
        bottomView.frame = CGRectMake(0, 63, 320, 1);
        
        if(errorLabel){
            errorLabel.center = CGPointMake(160, 240);
        }
        if(loadingLabel){
            loadingLabel.center = CGPointMake(145, 22);
        }
        if(indicatorView){
            indicatorView.center = CGPointMake(200, 22);
        }
    }
    
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;    
}

- (void)dealloc {
    [videoURL release];
    [playerVC release];
    
    [beginDate release];
    [endDate release];
    
    [gradientV release];
    
    [super dealloc];
}
@end