//
//  VAdLogo.m
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VAdLogo.h"
#import "ImageCache.h"
#import "UIImageExtend.h"
#import "ImageManipulator.h"
#import "MAd.h"
#import "AppDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation VAdLogo
@synthesize mad;
@synthesize ui_img_view;
@synthesize appDetailController;
@synthesize ui_indicatorView;
@synthesize ui_indicator;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_dark.png"]];
		backImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self addSubview:backImgView];
		[backImgView release];
		
		self.ui_img_view=[[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]autorelease];
		[self.ui_img_view addTarget:self action:@selector(redirectToApp) forControlEvents:UIControlEventTouchUpInside];
		self.ui_img_view.backgroundColor = [UIColor clearColor];
		[self addSubview:self.ui_img_view];
		
		self.ui_indicatorView=[[[UIView alloc]initWithFrame:CGRectMake(5, 5, 55, 55)]autorelease];
		self.ui_indicator=[[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
		[self.ui_indicatorView addSubview:self.ui_indicator];
		self.ui_indicator.center=CGPointMake(22, 22);
		[self.ui_indicator startAnimating];
		[self addSubview:self.ui_indicatorView];
		
		self.backgroundColor=[UIColor whiteColor];
		
//		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//		self.layer.borderWidth = 1;
//		self.layer.cornerRadius = 6;
    }
    return self;
}
-(void)redirectToApp{
	
	NSLog(@"redirect to app.");
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.mad.sourceURL]];

}
-(void)bindItem{
	if (self.mad!=nil) {
		UIImage *tempimg=[ImageCache loadFromCacheWithID:[mad.logo lastPathComponent] andDir:DIR_LIST];
		if(tempimg==nil)
		{
			NSInvocationOperation *opt=[[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage) object:nil]autorelease];
			[[self.appDetailController picqueue] addOperation:opt];
		}
		else
		{
			[self performSelectorOnMainThread:@selector(setImageView:) withObject:[ImageManipulator makeRoundCornerImage:tempimg :28 :28] waitUntilDone:YES];
		}
	}
}

-(void)loadImage{
	UIImage *tempimg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mad.logo]]];
	[ImageCache saveToCacheWithID:[self.mad.logo lastPathComponent] andImg:tempimg andDir:DIR_LIST];
	[self performSelectorOnMainThread:@selector(setImageView:) withObject:[ImageManipulator makeRoundCornerImage:tempimg :28 :28]  waitUntilDone:YES];
	
}
-(void)setImageView:(UIImage *)img{
	[self.ui_img_view setBackgroundImage:[img imageWithShadow] forState:UIControlStateNormal];
	[img release];
	[self.ui_indicator removeFromSuperview];
	self.ui_indicator=nil;
	[self.ui_indicatorView removeFromSuperview];
	self.ui_indicatorView=nil;
	self.backgroundColor=[UIColor clearColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.ui_img_view=nil;
	self.mad=nil;
	self.ui_indicatorView=nil;
	
	self.appDetailController = nil;
	self.ui_indicator=nil;
    [super dealloc];
}


@end
