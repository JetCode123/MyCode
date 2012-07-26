//
//  MessageTool.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "MessageTool.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageTool

//把自己添加到一个视图上
-(id)initWithView:(UIView *)view{
	self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
	if(self){
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.7;
		
		[UIView beginAnimations:@"" context:nil];
		[UIView setAnimationDuration:0.6];
		self.alpha = 0;
		self.alpha = 0.7;
		[UIView commitAnimations];
		
		self.layer.cornerRadius = 10;
		self.frame = CGRectMake(0, 0, 160, 160);
		self.center = CGPointMake(view.frame.size.width / 2,view.frame.size.height / 2);
		[view addSubview:self];
	}
	return self;
}


-(id)initWithView:(UIView *)view forType:(NSString *)vType{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 64, 320, 35);
        self.alpha = 0;
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bn_jsq" ofType:@"png"]];
        UIImageView *backImage = [[UIImageView alloc] initWithImage:img];
        backImage.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        backImage.alpha = 0;
        [UIView beginAnimations:@"exmp" context:nil];
        [UIView setAnimationDuration:0.6];
        self.alpha = 1;
        backImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        backImage.alpha = 1;
        [UIView commitAnimations];
        [self addSubview:backImage];
        [view addSubview:self];
        [backImage release];
    }
    return self;
}

-(void)insertLoading:(NSString *)explain{
    self.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *act = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [act startAnimating];
    act.center = CGPointMake(self.frame.size.width / 2 - 60, self.frame.size.height / 2 - 35);
    
    UILabel *lbl = [[[UILabel alloc] init] autorelease];
    lbl.font = [UIFont systemFontOfSize:12];
    CGSize size = [explain sizeWithFont:lbl.font];
    lbl.frame = CGRectMake(0, 0, size.width, size.height);
    lbl.textColor = [UIColor grayColor];
    
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.textColor = [UIColor whiteColor];
    lbl.text = explain;
    lbl.center = CGPointMake(self.frame.size.width / 2 + 10, self.frame.size.height / 2 - 35);
    
    [self addSubview:act];
    [self addSubview:lbl];
    
}

-(void)showLoading:(NSString *)explain{
    UIActivityIndicatorView *act = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [act startAnimating];
    act.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 25);
    
    UILabel *lbl = [[[UILabel alloc] init] autorelease];
    CGSize size = [explain sizeWithFont:[UIFont systemFontOfSize:16]];
    lbl.frame = CGRectMake(0, 0, size.width, size.height);
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.text = explain;
    lbl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 30);
    
    [self addSubview:act];
    [self addSubview:lbl];
}

-(void)showNetworkStatus:(BOOL)status{
    UIImage *img = [UIImage imageNamed:@"icon_error.png"];
    if (status) {
        img = [UIImage imageNamed:@"icon_network.png"];
    }
    
    UIImageView *imgView = [[[UIImageView alloc] initWithImage:img] autorelease];
    imgView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 20);
    
    UILabel *lbl = [[[UILabel alloc] init] autorelease];
    if (status) {
        lbl.text = @"网络已链接";
    }else{
        lbl.text = @"网络已断开";
    }
    CGSize size = [lbl.text sizeWithFont:[UIFont systemFontOfSize:16]];
    lbl.frame = CGRectMake(0, 0, size.width, size.height);
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 40);
    
    [self addSubview:imgView];
    [self addSubview:lbl];
}


-(void)hideMessage{
    [self removeFromSuperview];
}

-(void)showLoadingStatus:(BOOL)status{
    UILabel *lblStatus = [[UILabel alloc] init];
    lblStatus.font = [UIFont systemFontOfSize:14];
    lblStatus.textColor = [UIColor whiteColor];
    lblStatus.backgroundColor = [UIColor clearColor];
    if (status) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setAMSymbol:@"AM"];
        [dateFormatter setPMSymbol:@"PM"];
        [dateFormatter setDateFormat:@"今天 hh:mm"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        lblStatus.text = [NSString stringWithFormat:@"已更新 %@",strDate];
        [dateFormatter release];
    }else{
        lblStatus.text = @"数据更新失败  : -(";
    }
    CGSize size = [lblStatus.text sizeWithFont:lblStatus.font];
    lblStatus.frame = CGRectMake(self.frame.size.width / 2 - size.width / 2, self.frame.size.height / 2 - size.height / 2 - 1, size.width, size.height);
    
    [self addSubview:lblStatus];
    [lblStatus release];
}


-(void)hideLoadingStatus{
    [UIView beginAnimations:@"loadingStatus" context:nil];
    [UIView setAnimationDuration:0.4];
    self.alpha = 0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    [UIView commitAnimations];
    [self performSelector:@selector(hideMessage) withObject:self afterDelay:0.4];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
