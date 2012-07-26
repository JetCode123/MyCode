//
//  PlayerViewController.h
//  LimitedFreePro
//
//  Created by lu jiaolong on 11-10-31.
//  Copyright (c) 2011年 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class GradientView;

@interface PlayerViewController : UIViewController{
    NSURL *videoURL;
    MPMoviePlayerViewController *playerVC;
    NSDate *beginDate,*endDate;
    BOOL isLoadOver;
    NSTimer *timer;
    BOOL haveNetwork;
    
    GradientView *gradientV;
}

@property (nonatomic,retain) NSURL *videoURL;
@property (nonatomic,retain) MPMoviePlayerViewController *playerVC;

@property (nonatomic,retain) NSDate *beginDate;
@property (nonatomic,retain) NSDate *endDate;
@property (nonatomic) BOOL isLoadOver;
@property (nonatomic) BOOL haveNetwork;

@property (nonatomic,retain) GradientView *gradientV;
- (void)readyPlayer;
- (void)judgeTheLoadStatus;

- (void)doneAction:(id)sender;

@end
