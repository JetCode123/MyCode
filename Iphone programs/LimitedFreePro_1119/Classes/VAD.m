//
//  VAD.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-2.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "VAD.h"
#import "AppDetailsViewController.h"
#import "Contants.h"
#import "DAD.h"
#import "MAd.h"
#import "VAdLogo.h"

@implementation VAD

@synthesize appDetailController;
@synthesize infoLabel;
@synthesize data;
@synthesize totalCount;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)asynInit{
	if([[NSUserDefaults standardUserDefaults] objectForKey:AdCache] != nil){
		self.data = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:AdCache]];
		[self addImageView];
	}
	
	else{
		NSInvocationOperation *opt = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadAd) object:nil];
		// TODO: self.appDetailController.
		[self.appDetailController.queue addOperation:opt];
		[opt release];
	}
}

-(void)addImageView{
	//NSLog(@"self.data.count = %d",self.data.count);
	
	if(self.data != nil){
		self.infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)] autorelease];
		self.infoLabel.text = @"下载更多应用请使用以下软件";
		self.infoLabel.backgroundColor = [UIColor clearColor];
		self.infoLabel.font = [UIFont systemFontOfSize:13.f];
		[self addSubview:self.infoLabel];
		
		for(int i = 0; i < [self.data count]; i++){
			MAd *mad = [self.data objectAtIndex:i];
			VAdLogo *adLogo = [[VAdLogo alloc] initWithFrame:CGRectMake(5+(55+20)*i, 30, 55, 55)];
			adLogo.appDetailController = self.appDetailController;
			adLogo.mad = mad;
			[adLogo bindItem];
			[self addSubview:adLogo];
			[adLogo release];
		}
		
	}
}

-(void)loadAd{
	self.data = [DAD getADList];
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.data] forKey:AdCache];
	[self performSelectorOnMainThread:@selector(addImageView) withObject:nil waitUntilDone:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.infoLabel = nil;
	self.data = nil;
	
    [super dealloc];
}


@end
