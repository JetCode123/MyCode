//
//  CategoryView.m
//  TimeLimitFree
//
//  Created by lu jiaolong on 11-8-29.
//  Copyright 2011 sensosourcing Inc Beijing. All rights reserved.
//

#import "CategoryView.h"
#import "Contants.h"
#import "RootViewController.h"
#import "CategoryViewController.h"
#import "MobClick.h"

@implementation CategoryView
@synthesize _logoImgView,_nameLabel,_currentCategory,orderIndex,_type,_cateVC;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		//self.layer.cornerRadius = 8;
		
		self._logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 5, 50, 50)];
		[self addSubview:self._logoImgView];
		[_logoImgView release];
		
		self._nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 55, 30, 20)];
		self._nameLabel.font = [UIFont systemFontOfSize:12.f];
		self._nameLabel.backgroundColor = [UIColor clearColor];
		self._nameLabel.textColor = [UIColor darkGrayColor];
		[self addSubview:self._nameLabel];
		[self._nameLabel release];
    }
	
    return self;
}

-(void)bindItem{
	if(self._currentCategory != nil){
		self._logoImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png",self._currentCategory._cateID]];
		self._nameLabel.text = self._currentCategory._cateName;
	}
}

-(void)showBgColor{
	[self setBackgroundColor:[UIColor colorWithRed:0.125 green:0.392 blue:0.769 alpha:1]];
}

-(void)hideBgColor{
	[self setBackgroundColor:[UIColor clearColor]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count] == 1){

//		NSLog(@"touch begin");
		lastTouchX = [[touches anyObject] locationInView:self].x;
		lastTouchY = [[touches anyObject] locationInView:self].y;
		[self showBgColor];
	}
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[self hideBgColor];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSInteger currentTouchX = [[touches anyObject] locationInView:self].x;
	NSInteger currentTouchY = [[touches anyObject] locationInView:self].y;
	
	if(abs(lastTouchX - currentTouchX) < 30 && abs(lastTouchY - currentTouchY) < 30){
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.orderIndex] forKey:KEY_CATEINDEX];
		
		//UINavigationController *navController = (UINavigationController *)self._cateVC.navigationController;
		_navCtrl = (UINavigationController *)self._cateVC.navigationController;
		[self._cateVC pop];
		
		[self performSelector:@selector(delay) withObject:nil afterDelay:0.0];
	}
}

-(void)delay{
	rootVC = (RootViewController *)_navCtrl.topViewController;
	//RootViewController *rootVC = (RootViewController *)navController.topViewController;
	
	[rootVC._conListDict setObject:[NSNumber numberWithInt:self._currentCategory._cateID] forKey:KEY_CATEGORYID];
	[rootVC performSelector:@selector(clickReload) withObject:nil afterDelay:1];
	
	NSString *_cateStr = self._currentCategory._cateName;
	
	_cateStr = [_cateStr stringByAppendingString:@"+"];
	
	if([self._currentCategory._cateName isEqualToString:@"全部"]){
		_cateStr = @"";
	}
	
	NSString *_orderStr = [rootVC._conListDict valueForKey:KEY_ORDER];
	NSString *_fenleiStr;
	if([_orderStr isEqualToString:@"New"]){
		_fenleiStr = @"最新排行";
	}
	else if([_orderStr isEqualToString:@"Hot"]){
		_fenleiStr = @"最热排行";
	}
	else if([_orderStr isEqualToString:@"Score"]){
		_fenleiStr = @"评分最高";
	}
	else{
		_fenleiStr = @"价格最贵";
	}
	
	UIButton *titleBtn = (UIButton *)rootVC.navigationItem.titleView;
	[titleBtn setTitle:[NSString stringWithFormat:@"%@%@",_cateStr,_fenleiStr] forState:UIControlStateNormal];
		
	[MobClick event:@"分类" label:self._currentCategory._cateName];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self hideBgColor];
}


- (void)dealloc {
	self._logoImgView = nil;
	self._nameLabel = nil;
	self._currentCategory = nil;
	self._type = nil;
	self._cateVC = nil;
	
    [super dealloc];
}


@end
