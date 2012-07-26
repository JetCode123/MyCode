//
//  AppPicView.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppPicView.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageCache.h"
#import "AppExampleImageController.h"
#import "AppDetailsViewController.h"

@implementation AppPicView
@synthesize imageURL;
@synthesize mainView;
@synthesize imageWidth;
@synthesize imageHeight;
@synthesize index;
@synthesize isShow;
@synthesize downloader;
@synthesize photoLoadView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
		self.layer.borderWidth = 1;
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"touch end.");
	
	for(UIView *v in [self.mainView subviews]){
		AppPicView *picView = (AppPicView *)v;
		if([[v subviews] count] > 0){
			if([[[v subviews] objectAtIndex:0] isKindOfClass:NSClassFromString(@"UIImageView")]){
				UIImageView *imageView = (UIImageView *)[[v subviews] objectAtIndex:0];
				[self.mainView.imageDict setValue:imageView.image forKey:[NSString stringWithFormat:@"%i",picView.index]];
			}
		}
	}
	
	if([self.mainView.imageDict count] < 1 || !self.isShow){
		return;
	}
	
	AppExampleImageController *example = [[AppExampleImageController alloc] init];
	example.imageDict = self.mainView.imageDict;
	example.currentPage = self.index;
	example.listView = self;
	example.view.frame = CGRectMake(0, 0, 320, 480);
	
	CGFloat y = self.mainView.detailController._detailsViewTwo.frame.origin.y + 
					self.mainView.frame.origin.y + self.frame.origin.y - self.mainView.detailController._scrollView.contentOffset.y + 44 + 30;
	example.imagePoint = CGPointMake(40, y);
	[UIApplication sharedApplication].statusBarHidden = YES;
	[[UIApplication sharedApplication].keyWindow addSubview:example.view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)downloadError{
	[self.photoLoadView removeFromSuperview];
	self.backgroundColor = [UIColor whiteColor];
	
	UILabel *label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:14];
	label.text = @"图片加载失败";
	CGSize size = [label.text sizeWithFont:label.font];
	label.frame = CGRectMake(0, 0, size.width, size.height);
	label.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self addSubview:label];
	[label release];
}

-(void)dataDivLoad:(NSMutableData *)data url:(NSString *)url{
	[self.photoLoadView removeFromSuperview];
	self.backgroundColor = [UIColor whiteColor];
	
	UIImage *image = [UIImage imageWithData:data];
	[ImageCache saveToCacheWithID:[url lastPathComponent] andImg:image andDir:DIR_DETAIL];
	[self setImageView:image];
}


-(void)showImage{
	UIImage *image = [ImageCache loadFromCacheWithID:[self.imageURL lastPathComponent] andDir:DIR_DETAIL];
	if(image == nil){
		self.backgroundColor = [UIColor lightGrayColor];
		self.photoLoadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self.photoLoadView startAnimating];
		self.photoLoadView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
		[self addSubview:self.photoLoadView];
		[self.photoLoadView release];
		
		self.downloader = [[DataDownloader alloc] init];
		downloader.delegate = self;
		[downloader startDownload:self.imageURL];
		[self.downloader release];
	}
	
	else 
		[self setImageView:image];
}


-(void)setImageView:(UIImage *)img{
	UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
	imageView.frame = CGRectMake(10, 10, 240, 360);
	
	if(self.imageWidth > self.imageHeight){
		imageView.transform = CGAffineTransformMakeRotation(3 * M_PI / 2);
		imageView.frame = CGRectMake(10, 10, 240, 360);
	}
	
	[self addSubview:imageView];
	[imageView release];
	self.isShow = YES;
}

- (void)dealloc {
	[self.downloader cancelDownload];
	self.imageURL = nil;
	self.mainView = nil;
	self.downloader.delegate = nil;
	self.downloader = nil;
	self.photoLoadView = nil;
    [super dealloc];
}


@end
