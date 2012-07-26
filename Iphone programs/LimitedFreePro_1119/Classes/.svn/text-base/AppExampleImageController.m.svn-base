    //
//  AppExampleImageController.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppExampleImageController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDetailsViewController.h"

@implementation AppExampleImageController
@synthesize scrollView;
@synthesize pageControl;
@synthesize exampleImageArray;
@synthesize numberPages;

@synthesize imageViews;
@synthesize imageDict;
@synthesize imagePoint;
@synthesize currentPage;
@synthesize listView;

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	for(int i = 0; i < self.numberPages; i ++){
		UIImage *image = [self.imageDict valueForKey:[NSString stringWithFormat:@"%i",i]];
		UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
		if(image.size.width > image.size.height){
			imgView.transform = CGAffineTransformMakeRotation(3 * M_PI / 2);
			imgView.frame = CGRectMake(i * 320, 0, 320, 480);
		}
		else {
			imgView.frame = CGRectMake(320 * i, 0, 320, 480);
		}
		
		[self.scrollView addSubview:imgView];
		if(self.currentPage == i){
			[UIView beginAnimations:@"exam" context:nil];
			[UIView setAnimationDuration:0.7];
			self.view.alpha = 0;
			self.view.alpha = 1.0;
			imgView.frame = CGRectMake(320 * i + 40, self.imagePoint.y, 240, 360);
			imgView.frame = CGRectMake(320 * i , 0, 320, 480);
			[UIView commitAnimations];
		}
		[imgView release];
	}
	
	UIImageView *closeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnClose.png"]];
	closeImg.frame = CGRectMake(270, 10, 40, 40);
	[self.view addSubview:closeImg];
	[closeImg release];
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	[self performSelector:@selector(addClick) withObject:self afterDelay:0.8];
	self.view.backgroundColor = [UIColor blackColor];
	
	self.numberPages = [self.imageDict count];
	
	self.scrollView = [[[UIScrollView alloc] init] autorelease];
	self.scrollView.frame = CGRectMake(0, 0, 320, 480);
	self.scrollView.contentSize = CGSizeMake(320 * self.numberPages, 480);
	self.scrollView.contentOffset = CGPointMake(320 * self.currentPage, 0);
	self.scrollView.delegate = self;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.pagingEnabled = YES;
	
	self.pageControl = [[[UIPageControl alloc] init] autorelease];
	self.pageControl.numberOfPages = self.numberPages;
	self.pageControl.currentPage = self.currentPage;
	self.pageControl.center = CGPointMake(160, 450);
	
	[self.view addSubview:self.scrollView];
	[self.view addSubview:self.pageControl];
}

-(void)addClick{
	UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
	[self.view addGestureRecognizer:click];
	[click release];
}

-(void)click{
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.listView.mainView.detailController.navigationController setNavigationBarHidden:YES];
	[self.listView.mainView.detailController.navigationController setNavigationBarHidden:NO];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	self.view.alpha = 0.00;
	[UIView commitAnimations];
	
	[self performSelector:@selector(removeSelf) withObject:self afterDelay:0.8];
}

-(void)removeSelf{
	self.navigationController.navigationBarHidden = NO;
	[self.view removeFromSuperview];
	
	self.scrollView = nil;
	self.pageControl = nil;
	[self.exampleImageArray removeAllObjects];
	self.exampleImageArray = nil;
	
	[self.imageViews removeAllObjects];
	self.imageViews = nil;
	
	self.imageDict = nil;
	self.listView = nil;
	self.view = nil;
	self = nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	int num = (int)self.scrollView.contentOffset.x	% 320;
	if(num == 0){
		int current = self.scrollView.contentOffset.x / 320;
		self.pageControl.currentPage = current;
	}
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.view removeFromSuperview];
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
	
	self.scrollView = nil;
	self.pageControl = nil;
	self.exampleImageArray = nil;
	
	self.imageDict= nil;
	self.imageViews = nil;
	
	self.listView = nil;
    [super dealloc];
}


@end
