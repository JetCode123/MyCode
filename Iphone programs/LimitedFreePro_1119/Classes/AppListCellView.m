//
//  AppListCellView.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-24.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppListCellView.h"
#import "AppListBasedCell.h"
#import "MApp.h"
#import "AppListViewController.h"
#import "Contants.h"

#import "AppListCell.h"

#define kStarImageWidth 105
#define kStarImageHeight 21

#define	kSwipeYDistance 10
#define kSwipeXDistance 20
#define kTwoPointsDisctance 10

#define kImageEdgeValue 12

@implementation AppListCellView

@synthesize _contentCell;
@synthesize _appListVC;
@synthesize _detailImageView,_detailLabel;

@synthesize _indexPath,_tableView,_basedCell;

-(id)initWithFrame:(CGRect)frame andCell:(AppListCell *)cell{
	self = [super initWithFrame:frame];
	if(self){
		// 获取单元格对象，为后面的页面元素传值。
		
		self._contentCell = cell;
		self.backgroundColor = self._contentCell.backgroundColor;
		
		// 一句话简介:
		UITextView *_textView = [[UITextView alloc] initWithFrame:CGRectMake(78, ROW_HEIGHT - 5 - 38, 230, 38)];
		_textView.tag = 100;
		_textView.backgroundColor = [UIColor clearColor];
		_textView.editable = NO;
		_textView.textColor = [UIColor darkGrayColor];
		_textView.userInteractionEnabled = NO;
		_textView.font = [UIFont systemFontOfSize:12.f];
		[self addSubview:_textView];
		[_textView release];
		
		// $ 上的线 :
		UIImageView *_lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 13)];   //  55 ,1
   		_lineView.tag = 10000;
		_lineView.center = CGPointMake(210+40, 50 - 5);
		_lineView.backgroundColor = [UIColor clearColor];
		_lineView.image = [UIImage imageNamed:@"xixian.png"];
		//_lineView.transform = CGAffineTransformMakeRotation(M_PI / 12);
		[self addSubview:_lineView];
		[_lineView release];
		
		UIImage *shuxian_image = [UIImage imageNamed:@"xfg.png"];
		UIImageView *shuxian = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 15)];
		shuxian.center = CGPointMake(124 + 5, 48 - 3);
		shuxian.image = shuxian_image;
		[self addSubview:shuxian];
		[shuxian release];
		
		_detailImageView = [[UIImageView alloc] init];
		_detailImageView.frame = CGRectMake(0, 66 + 8, 76, 18);
		_detailImageView.backgroundColor = [UIColor clearColor];
		_detailImageView.tag = 101;
		[self addSubview:_detailImageView];
		[_detailImageView release];
		
		_detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 76, 18)];
		_detailLabel.center = CGPointMake(_detailImageView.frame.size.width / 2 - 6, 
										  _detailImageView.frame.origin.y  + _detailImageView.frame.size.height / 2);
		_detailLabel.backgroundColor = [UIColor clearColor];
		_detailLabel.tag = 102;
		_detailLabel.font = [UIFont boldSystemFontOfSize:11.f];
		_detailLabel.textColor = [UIColor whiteColor];
		_detailLabel.textAlignment = UITextAlignmentCenter;
	
		_detailLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		_detailLabel.shadowOffset = CGSizeMake(1, 1);
		
		[self addSubview:_detailLabel];
		[_detailLabel release];
        
        
//        UIImageView *videoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//        videoImgView.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
//        videoImgView.tag = 2211;
//        [self addSubview:videoImgView];
//        [videoImgView release];
	}
	return self;
}

-(void)setContentCell:(AppListCell *)cell{
	self._contentCell = cell;
	[self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
	
    /*  
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 0, 20, 20)];
    testView.backgroundColor = [UIColor redColor];
    [self addSubview:testView];
    [testView release]; 
    */
    
	//	NSLog(@"日期：%@",_detailLabel.text);
	
	//	if([_detailLabel.text isEqualToString:@"09月11日"]){
	//		_detailLabel.text = @"今日限免";
	//	}
	
//    日期比较。。。
    MApp *_app = self._contentCell._app;
    
	NSString *_todayString = [AppListCellView stringWithDate:[NSDate date]];
	NSString *_yesterdayString = [AppListCellView stringWithDate:[NSDate dateWithTimeInterval:-(24 * 60 * 60) sinceDate:[NSDate date]]];
	
	NSString *shortForToday = [[_todayString substringFromIndex:5] stringByAppendingString:@" "];
	NSString *shortForYesterday = [[_yesterdayString substringFromIndex:5] stringByAppendingString:@" "];
	
	NSString *riqiTodayStr = [shortForToday stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
	riqiTodayStr = [riqiTodayStr stringByReplacingOccurrencesOfString:@" " withString:@"日"];
	
	
	NSString *riqiYesterdayStr  = [shortForYesterday stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
	riqiYesterdayStr = [riqiYesterdayStr stringByReplacingOccurrencesOfString:@" " withString:@"日"];
	
	if([_detailLabel.text isEqualToString:riqiTodayStr])
		_detailLabel.text = @"今日限免";
	if([_detailLabel.text isEqualToString:riqiYesterdayStr])
		_detailLabel.text = @"昨日限免";
	
    
	float diyihang = 7;
	float dierhang = 31;
	
	_detailImageView.image = (_app._appIsNew == YES) ? [UIImage imageNamed:@"jrxm.png"] : [UIImage imageNamed:@"zrxm.png"];
	
	// 分类
	UIColor	*_infoColor = [UIColor colorWithRed:0.373 green:0.373 blue:0.373 alpha:1];
	[_infoColor set];
	
	UIFont *_infoFont = [UIFont systemFontOfSize:12];
	[_app._appCateName drawAtPoint:CGPointMake(135 + 7 , dierhang - 1 + 12 - 5 + 0.5) withFont:_infoFont];
	
	// 单价
	UIColor *_priceColor = [UIColor colorWithRed:0.325 green:0.620 blue:0.827 alpha:1];
	[_priceColor set];
	
	CGSize size = [_app._appStrPrice sizeWithFont:[UIFont systemFontOfSize:16]];
	[_app._appStrPrice drawAtPoint:CGPointMake(40+230 - size.width - 5, dierhang - 2 + 8 - 5) withFont:[UIFont systemFontOfSize:20.f]];
	
	//	hengxianCenter = CGPointMake(40+230 - size.width - 5 + size.width / 2, dierhang -2 + 8 + size.height / 2);
	//	UIView *_lineView = (UIView *)[self viewWithTag:10000];
	//	_lineView.center = hengxianCenter;
	
	UIImage *_accessoryImg = [UIImage imageNamed:@"jinrfh.png"];
	[_accessoryImg drawAtPoint:CGPointMake(298, ROW_HEIGHT / 2 - 28 / 2)];
	[_accessoryImg release];
	
	UIColor *_titleColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
	[_titleColor set];
	
	// 名称
	NSString *_name = [NSString stringWithFormat:@"%i.%@",self._contentCell._orderIndex,_app._appName];
	CGSize nameSize = [_name sizeWithFont:[UIFont boldSystemFontOfSize:15]];
	
	if(nameSize.width > 228){nameSize.width = 228;} // 宽度控制在220＋起始的80　文字长度到头最大不超过　300
	
	[_name drawInRect:CGRectMake(84, diyihang, nameSize.width + 10, 20) withFont:[UIFont boldSystemFontOfSize:15]];
    
    
    UIImage *videoimage = [UIImage imageNamed:@"iphone_video.png"];
    UIImage *transformImage;
    
    if(_app._appHasVideo){
        if(videoimage.size.width != kImageEdgeValue && videoimage.size.height != kImageEdgeValue){
            CGSize itemSize = CGSizeMake(kImageEdgeValue, kImageEdgeValue);
            UIGraphicsBeginImageContext(itemSize);
            [videoimage drawInRect:CGRectMake(0, 0, kImageEdgeValue, kImageEdgeValue)];
            transformImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [transformImage drawAtPoint:CGPointMake(88 + nameSize.width, diyihang + 2)];
        }
        
        else
            [videoimage drawAtPoint:CGPointMake(88 + nameSize.width, diyihang + 3.5)];
    }
    
//    字体的范围控制在　width <= 218 ,右边origin.x <= 218 + 84=302 余留18pix.
	
	UIColor *_scoreColor = [UIColor darkGrayColor];
	[_scoreColor set];
	
	if(_app._appScore > 0){		
		[_app._appStrScore drawAtPoint:CGPointMake(86, dierhang + 12 - 5) withFont:[UIFont systemFontOfSize:12.f]];
	}
	
	else 
		[_app._appStrScore drawAtPoint:CGPointMake(86, dierhang + 12 - 5) withFont:[UIFont systemFontOfSize:11.f]];
	
	//评分图标
	
	//	UIImage *bottom5Star = [UIImage imageNamed:@"xingxtb.png"];
	//	
	//	if(bottom5Star.size.width != kStarImageWidth && bottom5Star.size.height != kStarImageHeight){
	//		CGSize itemSize = CGSizeMake(kStarImageWidth, kStarImageHeight);
	//		
	//		UIGraphicsBeginImageContext(itemSize);
	//		CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
	//		[bottom5Star drawInRect:imageRect];
	//		bottom5Star = UIGraphicsGetImageFromCurrentImageContext();
	//		UIGraphicsEndImageContext();
	//	}
	//	[bottom5Star drawAtPoint:CGPointMake(76, dierhang + 5)];
	//	
	//	float bili = [self getAppScore:_app._appScore] / 5.0;
	//	if(_app._appScore > 0){
	//		UIImage *top5Star = [UIImage imageNamed:@"xingxt.png"];
	//		if(top5Star.size.width != kStarImageWidth && top5Star.size.height != kStarImageHeight){
	//			CGSize itemSize = CGSizeMake(kStarImageWidth, kStarImageHeight);
	//			UIGraphicsBeginImageContext(itemSize);
	//			CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
	//			[top5Star drawInRect:imageRect];
	//			top5Star = UIGraphicsGetImageFromCurrentImageContext();
	//			UIGraphicsEndImageContext();
	//		}
	//		
	//		UIRectClip(CGRectMake(76, dierhang + 5, kStarImageWidth * bili, kStarImageHeight));
	//		[top5Star drawAtPoint:CGPointMake(76, dierhang + 5)];
	//	}
	
	UITextView *_textView = (UITextView *)[self viewWithTag:100];
	if(_app._appBriefSummary)
		_textView.text = [NSString stringWithFormat:@"简 介:  %@",_app._appBriefSummary];
	if([_app._appBriefSummary isEqualToString:@""])
		_textView.text = [NSString stringWithFormat:@"简　介:%@",@"  暂无。"];
	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.userInteractionEnabled = YES;
    }
    return self;
}

+(NSString *)stringWithDate:(NSDate *)date{
	NSDateFormatter *_dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[_dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *_dateStr = [_dateFormatter stringFromDate:date];
	return [NSString stringWithString:_dateStr];
}

-(float)getAppScore:(float)value{
	int toTen =(int)(value * 10);
	int shangshu = toTen / 10;
	
	float panduan = value - shangshu;
	if(panduan > 0.5){
		return (shangshu + 1) / 2.0;
	}
	else if(panduan < 0.5){
		return shangshu / 2.0;
	}
	else{
		return shangshu / 2.0;
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	UITouch *touch = [touches anyObject];
	originalPoint = [touch locationInView:self];
	
	self._appListVC.tableView.scrollEnabled = NO;
	self._appListVC.tableView.allowsSelection = NO;
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPt = [touch locationInView:self];
	
	if(fabs(currentPt.x - originalPoint.x) >= kSwipeXDistance && fabs(currentPt.y - originalPoint.y) < kSwipeYDistance){
		if(currentPt.x < originalPoint.x){
// left swipe.
			[self._appListVC expandOut];
		}
		
		else if(currentPt.x > originalPoint.x){
//			NSLog(@"right swipe.");
			[self._appListVC drawBack];
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

	self._appListVC.tableView.scrollEnabled = YES;
	self._appListVC.tableView.allowsSelection = YES;

	UITouch *_endTouch = [touches anyObject];
	CGPoint _endPt = [_endTouch locationInView:self];
		
	double deltaX = originalPoint.x - _endPt.x;
	double deltaY = originalPoint.y - _endPt.y;
	
	double distance = sqrt(pow(fabs(deltaX), 2) + pow(fabs(deltaY), 2));
	
	if(!self._appListVC.isOrderViewOn){
		if(distance < kTwoPointsDisctance){
			self._basedCell.selectedBackgroundView = [[[UIView alloc] initWithFrame:self._basedCell.frame] autorelease];
			
			self._basedCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.122 green:0.408 blue:0.766 alpha:1.0];
			[self._basedCell setSelected:YES animated:YES];
			[self._appListVC tableView:self._tableView didSelectRowAtIndexPath:self._indexPath];
		}
	}

	else{
		if(distance < kTwoPointsDisctance){
			[self._appListVC drawBack];
		}
	}
	
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)dealloc {
	self._contentCell = nil;

	[_appListVC release];
	self._appListVC = nil;
	
	self._detailImageView = nil;
	self._detailLabel = nil;
	
	[_indexPath release];
	self._indexPath = nil;
	
	[_tableView release];
	self._tableView = nil;
	
	[_basedCell release];
	self._basedCell = nil;
	
    [super dealloc];
}


@end
