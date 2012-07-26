//
//  VShotPicture.h
//  LimitedFreePro
//
//  Created by lu jiaolong on 11-10-28.
//  Copyright (c) 2011年 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MApp;
@class AppDetailsViewController;

@interface VShotPicture : UIView{
    UIImageView *mBackImgView;
    UIButton *playBtn;
    MApp *app;
    BOOL isPictureOn;
    UIImage *img;
    AppDetailsViewController *_detailsVC;
    
}

@property (nonatomic,retain) UIImageView *mBackImgView;
@property (nonatomic,retain) UIButton *playBtn;
@property (nonatomic,retain) MApp *app;
@property (nonatomic) BOOL isPictureOn;
@property (nonatomic,retain) UIImage *img;

@property (nonatomic,retain) AppDetailsViewController *_detailsVC;

-(void)playVideo;
-(void)loadImage;
- (void)highLighted;
@end
