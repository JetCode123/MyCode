//
//  VShotPicture.m
//  LimitedFreePro
//
//  Created by lu jiaolong on 11-10-28.
//  Copyright (c) 2011年 SequelMedia. All rights reserved.
//

#import "VShotPicture.h"
#import "MApp.h"
#import "ImageCache.h"
#import "AppDetailsViewController.h"

@interface VShotPicture(private)
- (void)setBtnBackImg;
@end

@implementation VShotPicture

@synthesize mBackImgView;

@synthesize playBtn;
@synthesize app;
@synthesize isPictureOn;
@synthesize img;
@synthesize _detailsVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
/*
        图片加载等待提醒。。
        UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
        iv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        iv.center = CGPointMake(self.center.x - 33, self.center.y + 30);
        [iv startAnimating];
        [self addSubview:iv];
        [iv release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        label.center = CGPointMake(self.center.x + 25, self.center.y + 30);
        label.numberOfLines = 1;
        label.font = [UIFont boldSystemFontOfSize:13.f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor darkGrayColor];
        label.text = @"加载中...";
        [self addSubview:label];
        [label release];
*/
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playBtn setFrame:CGRectMake(3, 10, self.frame.size.width - 6, self.frame.size.height - 20)];
        [self.playBtn addTarget:self action:@selector(highLighted) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playBtn];
        
        
        mBackImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_sp.png"]];
        mBackImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:mBackImgView];
        [mBackImgView release];
        
    }
    return self;
}

- (void)highLighted{
    if(self.isPictureOn){
        [self._detailsVC turnTheBackImage];
    }
}

- (void)playVideo{
//    TODO:
    if(self.isPictureOn){        
        [self._detailsVC playAppVideo];
    }
}

- (void)loadImage {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"shot-picture-str = %@",self.app._appShotPictureStr);
    NSLog(@"picture-url = %@",self.app._appShotPictureURL);
    
    self.img = [ImageCache loadFromCacheWithID:self.app._appShotPictureStr andDir:DIR_SHOTPICTURE];
    NSLog(@"img = %@",img);
    if(!self.img){
        self.img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.app._appShotPictureURL]]];
        [ImageCache saveToCacheWithID:self.app._appShotPictureStr andImg:self.img andDir:DIR_SHOTPICTURE];

        [self performSelectorOnMainThread:@selector(setBtnBackImg) withObject:nil waitUntilDone:YES];
    }
    
    else {
        [self performSelectorOnMainThread:@selector(setBtnBackImg) withObject:nil waitUntilDone:YES];
    }
    
    
    self.isPictureOn = YES;

    [pool release];
}

- (void)setBtnBackImg{
    [self.playBtn setBackgroundImage:self.img forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc{
    [mBackImgView release];
    
    [self.playBtn release];
    [self.app release];
    [self.img release];
    [self._detailsVC release];
    
    [super dealloc];
}
@end
