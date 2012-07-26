//
//  OrderView.m
//  TimeLimitFree
//
//  Created by lu jiaolong on 11-8-28.
//  Copyright 2011 sensosourcing Inc Beijing. All rights reserved.
//

#import "OrderView.h"
#import "RootViewController.h"
#import "Contants.h"
#import "CFeedback.h"
#import "MobClick.h"
#import <QuartzCore/QuartzCore.h>

@implementation OrderView
@synthesize _rootVC;
@synthesize _typeID;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
	
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fenlei_bj.png"]];
		self.userInteractionEnabled = YES;
		
		_newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_newBtn.backgroundColor = [UIColor clearColor]; 
		_newBtn.frame = CGRectMake(0, 0, 24, 24);
		_newBtn.center = CGPointMake(45, 35);
		[_newBtn setBackgroundImage:[UIImage imageNamed:@"zuixin.png"] forState:UIControlStateNormal];
		_newBtn.userInteractionEnabled = NO;
//		[_newBtn addTarget:self action:@selector(newAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_newBtn];
		
		_newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		_newLabel.center = CGPointMake(45, 60);
		_newLabel.backgroundColor = [UIColor clearColor];
		_newLabel.font = [UIFont systemFontOfSize:14.f];
		_newLabel.textAlignment = UITextAlignmentCenter;
		_newLabel.textColor = [UIColor darkGrayColor];
		_newLabel.text = @"最新";

		
		[self addSubview:_newLabel];
		[_newLabel release];
		
		UIView *_v = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 90 - 20, 1)];
		_v.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:_v];
		[_v release];
		
		_hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_hotBtn.frame = CGRectMake(0, 0, 24, 24);
		_hotBtn.center = CGPointMake(45, 115);
		[_hotBtn setBackgroundImage:[UIImage imageNamed:@"zuire.png"] forState:UIControlStateNormal];
		_hotBtn.userInteractionEnabled = NO;

//		[_hotBtn addTarget:self action:@selector(hotAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_hotBtn];
		
		_hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		_hotLabel.center = CGPointMake(45, 140);
		_hotLabel.backgroundColor = [UIColor clearColor];
		_hotLabel.font = [UIFont systemFontOfSize:14.f];
		_hotLabel.textAlignment = UITextAlignmentCenter;
		_hotLabel.textColor = [UIColor darkGrayColor];
		_hotLabel.text = @"最热";
		[self addSubview:_hotLabel];
		[_hotLabel release];
		
		_v = [[UIView alloc] initWithFrame:CGRectMake(10, 80 + 80, 90 - 20, 1)];
		_v.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:_v];
		[_v release];
		
		_scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_scoreBtn.frame = CGRectMake(0, 0, 24, 24);
		_scoreBtn.center = CGPointMake(45, 195);
		[_scoreBtn setBackgroundImage:[UIImage imageNamed:@"pingfen.png"] forState:UIControlStateNormal];
		_scoreBtn.userInteractionEnabled = NO;

//		[_scoreBtn addTarget:self action:@selector(scoreAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_scoreBtn];
		
		_scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		_scoreLabel.center = CGPointMake(45, 220);
		_scoreLabel.backgroundColor = [UIColor clearColor];
		_scoreLabel.font = [UIFont systemFontOfSize:14.f];
		_scoreLabel.textAlignment = UITextAlignmentCenter;
		_scoreLabel.textColor = [UIColor darkGrayColor];
		_scoreLabel.text = @"评分";
		[self addSubview:_scoreLabel];
		[_scoreLabel release];
		
		_v = [[UIView alloc] initWithFrame:CGRectMake(10, 240 , 90 - 20, 1)];
		_v.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:_v];
		[_v release];
		
		_priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_priceBtn.frame = CGRectMake(0, 0, 24, 24);
		_priceBtn.center = CGPointMake(45, 275);
		[_priceBtn setBackgroundImage:[UIImage imageNamed:@"jiage.png"] forState:UIControlStateNormal];
		_priceBtn.userInteractionEnabled = NO;
//		[_priceBtn addTarget:self action:@selector(priceAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_priceBtn];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		_priceLabel.center = CGPointMake(45, 300);
		_priceLabel.backgroundColor =  [UIColor clearColor];
		_priceLabel.textAlignment  = UITextAlignmentCenter;
		_priceLabel.font = [UIFont systemFontOfSize:14.f];
		_priceLabel.textColor = [UIColor darkGrayColor];
		_priceLabel.text = @"最贵";
		[self addSubview:_priceLabel];
		[_priceLabel release];
		
		_v = [[UIView alloc] initWithFrame:CGRectMake(10, 320, 70, 1)];
		_v.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:_v];
		[_v release];

		
		_infoBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
		_infoBtn.frame = CGRectMake(0, 0, 30, 30);
		_infoBtn.center = CGPointMake(45, 350);
		_infoBtn.userInteractionEnabled = NO;
//		[_infoBtn addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_infoBtn];
		
		feedBackLabel = [[UILabel alloc] init];
		feedBackLabel.backgroundColor = [UIColor clearColor];
		feedBackLabel.font = [UIFont systemFontOfSize:13.f];
		feedBackLabel.text = @"意见反馈";

		CGSize size = [feedBackLabel.text sizeWithFont:feedBackLabel.font];
		feedBackLabel.frame = CGRectMake(0, 0, size.width, size.height);
		feedBackLabel.center = CGPointMake(45, 378);
		feedBackLabel.textAlignment = UITextAlignmentCenter;
		feedBackLabel.textColor = [UIColor darkGrayColor];
		[self addSubview:feedBackLabel];
		[feedBackLabel release];
		
		fenleiDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithString:@"全部"],@"24",
							@"工具",@"19",
							@"游戏",@"6",
							@"娱乐",@"4",
							@"图书",@"1",
							@"效率",@"14",
							@"生活",@"8",
							@"音乐",@"10",
							@"社交",@"16",
							@"教育",@"3",
							@"导航",@"11",
							@"商业",@"2",
							@"摄影",@"13",
							@"旅行",@"18",
							@"参考",@"15",
							@"新闻",@"12",
							@"财务",@"5",
							@"医疗",@"9",
							@"健康",@"7",
							@"体育",@"17",
					  @"天气",@"20",nil];
	}
    return self;
}

-(void)hotAction{

	[self smallForBtn:_hotBtn andLabel:_hotLabel];
	[self._rootVC performSelector:@selector(drawBack) withObject:nil afterDelay:0.45];

	[self performSelector:@selector(reloadMainViewController:) withObject:@"Hot" afterDelay:0.45];
}

-(void)newAction{
	//　1.动画效果(1.25->1) === 2.视图弹回去　=== 3.刷新tableview
	[self smallForBtn:_newBtn andLabel:_newLabel];
	
	[self._rootVC performSelector:@selector(drawBack) withObject:nil afterDelay:0.45];

	[self performSelector:@selector(reloadMainViewController:) withObject:@"New" afterDelay:0.45];

}

-(void)scoreAction{
	[self smallForBtn:_scoreBtn andLabel:_scoreLabel];
	[self._rootVC performSelector:@selector(drawBack) withObject:nil afterDelay:0.45];

	[self performSelector:@selector(reloadMainViewController:) withObject:@"Score" afterDelay:0.45];

}

-(void)priceAction{
	[self smallForBtn:_priceBtn andLabel:_priceLabel];
	[self._rootVC performSelector:@selector(drawBack) withObject:nil afterDelay:0.45];

	[self performSelector:@selector(reloadMainViewController:) withObject:@"Price" afterDelay:0.45];
}


-(void)feedAction{
	[self smallForBtn:_infoBtn andLabel:feedBackLabel];
    
    [self._rootVC performSelector:@selector(drawBack) withObject:nil afterDelay:0.45];
	[self performSelector:@selector(presentInfo) withObject:nil afterDelay:0.45];
	
//	[MobClick event:@"反馈"];
}

-(void)largeAndSmallWithBtn:(UIButton *)btn andLabel:(UILabel *)label{
	[UIView beginAnimations:@"large" context:nil];
	[UIView setAnimationDuration:1];
	btn.transform = CGAffineTransformMakeScale(2.25, 2.25);
	label.transform = CGAffineTransformMakeScale(2.25, 2.25);
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"small" context:nil];
	[UIView setAnimationDuration:1];
	btn.transform = CGAffineTransformIdentity;
	label.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)largeForBtn:(UIButton *)btn andLabel:(UILabel *)label{
//	[UIView beginAnimations:@"large" context:nil];
//	[UIView setAnimationDuration:1];
	btn.transform = CGAffineTransformMakeScale(2.25, 2.25);
	label.transform = CGAffineTransformMakeScale(2.25, 2.25);
//	[UIView commitAnimations];
}

-(void)smallForBtn:(UIButton *)btn andLabel:(UILabel *)label{
	[UIView beginAnimations:@"small" context:nil];
	[UIView setAnimationDuration:0.3];
	btn.transform = CGAffineTransformIdentity;
	label.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

-(void)presentInfo{
	
	CFeedback *feedBack = [[CFeedback alloc] init];

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:feedBack];
	//[nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_beijing.png"]];
	
	UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
	imgView.image = [UIImage imageNamed:@"top_beijing.png"];
	[nav.navigationBar addSubview:imgView];
	[nav.navigationBar insertSubview:imgView atIndex:0];
	
	[self._rootVC.navigationController presentModalViewController:nav animated:YES];
	[feedBack release];
	[nav release];
}

-(void)reloadMainViewController:(NSString *)orderStr{
	[self._rootVC._conListDict setObject:[NSString stringWithString:orderStr] forKey:KEY_ORDER];
	
	[self._rootVC clickReload];
	
	NSString *fenleiIDStr = [NSString stringWithFormat:@"%d",[[self._rootVC._conListDict objectForKey:KEY_CATEGORYID] intValue]];
	
	NSString *fenleiNameStr = [NSString stringWithFormat:@"%@",[fenleiDict objectForKey:fenleiIDStr]];
	NSString *fenlei = [fenleiNameStr stringByAppendingString:@"+"];
	if([fenleiIDStr isEqualToString:@"24"]){
		fenlei = @"";
	}
	
	NSLog(@"%@",fenlei);
	
	UIButton *titleBtn = (UIButton *)self._rootVC.navigationItem.titleView;
	
	if([orderStr isEqualToString:@"Hot"]){
		//self._rootVC.navigationItem.title = [NSString stringWithFormat:@"%@%@",fenlei,@"最热排行"];
		[titleBtn setTitle:[NSString stringWithFormat:@"%@%@",fenlei,@"最热排行"] forState:UIControlStateNormal];
	}
	else if([orderStr isEqualToString:@"New"]){
		//self._rootVC.navigationItem.title = [NSString stringWithFormat:@"%@%@",fenlei,@"最新排行"];
		[titleBtn setTitle:[NSString stringWithFormat:@"%@%@",fenlei,@"最新排行"] forState:UIControlStateNormal];
	}
	else if([orderStr isEqualToString:@"Score"]){
		//self._rootVC.navigationItem.title = [NSString stringWithFormat:@"%@%@",fenlei,@"评分排行"];
		[titleBtn setTitle:[NSString stringWithFormat:@"%@%@",fenlei,@"评分最高"] forState:UIControlStateNormal];
	}
	else{
		[titleBtn setTitle:[NSString stringWithFormat:@"%@%@",fenlei,@"价格最贵"] forState:UIControlStateNormal];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	UITouch *touch = [touches anyObject];

	CGPoint pt = [touch locationInView:self];

	if(CGRectContainsPoint(CGRectMake(0, 0, 90, 80), pt)){
		self._typeID = 1;
		
		[self largeForBtn:_newBtn andLabel:_newLabel];
		
		
		[MobClick event:@"排行" label:@"最新"];
	}
	
	else if(CGRectContainsPoint(CGRectMake(0, 80, 90, 80), pt)){
		self._typeID = 2;
		
		[self largeForBtn:_hotBtn andLabel:_hotLabel];
		[MobClick event:@"排行" label:@"最热"];
	}
	
	else if(CGRectContainsPoint(CGRectMake(0, 160, 90, 80), pt)){
		self._typeID = 3;
		
		[self largeForBtn:_scoreBtn andLabel:_scoreLabel];
		[MobClick event:@"排行" label:@"评分"];
	}
	else if(CGRectContainsPoint(CGRectMake(0, 240, 90, 80), pt)){
		self._typeID = 4;
		
		[self largeForBtn:_priceBtn andLabel:_priceLabel];
		[MobClick event:@"排行" label:@"最贵"];
	}
	
	else{
		self._typeID = 5;
		[self largeForBtn:_infoBtn andLabel:feedBackLabel];
        
        [MobClick event:@"反馈" label:@"反馈"];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
//	UITouch *touch = [touches anyObject];
		
//	if([touch tapCount] >= 2)
//		if(self._typeID == 1)
//			[self smallForBtn:_newBtn andLabel:_newLabel];
//		else if(self._typeID == 2)
//			[self smallForBtn:_hotBtn andLabel:_hotLabel];
//		else if(self._typeID == 3)
//			[self smallForBtn:_scoreBtn andLabel:_scoreLabel];
//	    else if(self._typeID == 4)
//			[self smallForBtn:_priceBtn andLabel:_priceLabel];
//		return;

	
	switch(self._typeID){
		case 1:
			[self newAction];
			break;
		case 2:
			[self hotAction];
			break;
		case 3:
			[self scoreAction];
			break;
		case 4:
			[self priceAction];
			break;
		case 5:
			[self feedAction];
			break;
		default:
			break;
	}
}

// remember this method.
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	switch(self._typeID){
		case 1:
			[self newAction];
			break;
		case 2:
			[self hotAction];
			break;
		case 3:
			[self scoreAction];
			break;
		case 4:
			[self priceAction];
			break;
		case 5:
			[self feedAction];
			break;
		default:
			break;
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[fenleiDict release];
    [_rootVC release];
	
	[super dealloc];
	
}


@end
