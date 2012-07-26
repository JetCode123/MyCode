    //
//  CategoryViewController.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "CategoryViewController.h"
#import "Contants.h"
#import "MCategory.h"
#import "CategoryView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CategoryViewController
@synthesize _cateItemList,_categoryData,_scrollView,isReload;

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	
	if([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CATEINDEX] != nil){
		NSInteger locatedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CATEINDEX] integerValue];
		
		if([self._cateItemList count] > locatedIndex && [self._cateItemList objectAtIndex:locatedIndex] != nil){
			CategoryView *cateView = (CategoryView *)[self._cateItemList objectAtIndex:locatedIndex];
			[cateView showBgColor];
			
			[UIView beginAnimations:@"淡出背景颜色" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:2];
			
			[cateView setBackgroundColor:[UIColor clearColor]];
			[UIView commitAnimations];
		}
	}
	

}


-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	for(UIView *_v in self.navigationController.navigationBar.subviews){
		if(_v && [_v isKindOfClass:NSClassFromString(@"UIImageView")]){
			[_v removeFromSuperview];
		}
	}
}
-(id)init {
	self = [super init];
	if(self){
//		self.navigationItem.title = @"分类";
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
		label.center = CGPointMake(160, 22);
		label.text = @"分类";
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont boldSystemFontOfSize:21];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(1, 1);
		self.navigationItem.titleView = label;
		[label release];
	}
	return self;
}

-(void)setNavigationItem{
	UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_backBtn.frame = CGRectMake(0, 0, 61, 30);
	[_backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
	[_backBtn setTitle:@"  返 回" forState:UIControlStateNormal];
	_backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
	[_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_backBtn] autorelease];
}

-(void)backAction{
	[self.navigationController popViewControllerAnimated:YES];
	
	NSLog(@"pop-count %d",self.navigationController.navigationBar.subviews.count);

}


-(void)viewDidLoad{
	[super viewDidLoad];
	
	
	[self setNavigationItem];

	[self showData];
}

-(void)showData{
	self.isReload  = YES;
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainBgV.png"]] autorelease];
	[self.view addSubview:bgImgView];
	
	self._cateItemList = [[[NSMutableArray alloc] init] autorelease];
	self._scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	self._scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 535);
	self._scrollView.showsVerticalScrollIndicator = NO;
	self._scrollView.showsHorizontalScrollIndicator = NO;
	
	self._scrollView.scrollsToTop = NO;
	self._scrollView.delegate = self;
	[self.view addSubview:self._scrollView];
	[self._scrollView release];
	
	NSMutableArray *data = [NSMutableArray array];
	
	NSMutableArray *idList,*nameList;
	if([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CATEGORY] == nil){
		idList = [NSMutableArray arrayWithObjects:
				  [NSNumber numberWithInteger:24], [NSNumber numberWithInteger:19],[NSNumber numberWithInteger:6],
				  [NSNumber numberWithInteger:4],[NSNumber numberWithInteger:1],
                  [NSNumber numberWithInteger:14],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:10],
                  [NSNumber numberWithInteger:16],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:11],
				  [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:13],
                  [NSNumber numberWithInteger:18],[NSNumber numberWithInteger:15],
				  [NSNumber numberWithInteger:12],
				  [NSNumber numberWithInteger:5],		 [NSNumber numberWithInteger:7],
                  [NSNumber numberWithInteger:9], [NSNumber numberWithInteger:17],[NSNumber numberWithInteger:20],nil];
        
		nameList = [NSMutableArray arrayWithObjects:@"全部",@"工具",@"游戏",@"娱乐",@"图书",
                    @"效率",@"生活",@"音乐",
                    @"社交",@"教育",@"导航",@"商业",@"摄影",
                    @"旅行",@"参考",@"新闻",
                    @"财务",@"健康",
                    @"医疗",@"体育",@"天气",nil];
		
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:idList] forKey:KEY_CATEGORY];
		[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:nameList] forKey:KEY_CATEGORY_NAME];
	}
	
	else{
		idList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CATEGORY]];
		nameList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_CATEGORY_NAME]];
	}
	
	if(idList != nil && nameList != nil && [idList count] == [nameList count]){
		for (int i = 0; i < [idList count]; i ++){
			MCategory *category = [[[MCategory alloc] init] autorelease];
			category._cateName = [nameList objectAtIndex:i];
			category._cateID = [[idList objectAtIndex:i] integerValue];
			category._hasSubCategory = NO;
			category._cateUpdateCount = 0;
			
			[data addObject:category];
			
			int width = (self._scrollView.frame.size.width - 10) / 4;
			int height = 80;
			int x = i % 4 * width + 5;
			int y = i / 4 * height + 5;
			
			CategoryView *_cateView = [[CategoryView alloc] initWithFrame:CGRectMake(x, y + 3, width, height - 6)];
			_cateView._currentCategory = category;
			_cateView.orderIndex = i;
			_cateView._cateVC = self;
			_cateView.layer.cornerRadius=8.0;
			[_cateView bindItem];
			
			[self._scrollView addSubview:_cateView];
			[self._cateItemList addObject:_cateView];
			[_cateView release];
			
			if(i % 4 == 0 && i != 0){
				UIImageView *_iv = [[[UIImageView alloc] initWithFrame:CGRectMake(10, y, 300, 2)] autorelease];
				_iv.image = [UIImage imageNamed:@"bottom.png"];
				[self._scrollView addSubview:_iv];
			}
		}
	}
}

-(void)pop{
	
	[self performSelector:@selector(delayBack) withObject:nil afterDelay:0];

}

-(void)delayBack{
	[self.navigationController popViewControllerAnimated:YES];
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self._cateItemList = nil;
	self._categoryData = nil;
	self._scrollView = nil;
	
    [super dealloc];
}


@end
