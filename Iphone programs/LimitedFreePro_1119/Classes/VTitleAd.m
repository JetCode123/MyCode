//
//  VTitleAd.m
//  限时免费_me
//
//  Created by lujiaolong on 11-9-13.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "VTitleAd.h"
#import "Contants.h"
#import "AppListViewController.h"
#import "MAd.h"
#import "MApp.h"
#import "VFirstPageLogo.h"
#import "AdDownloader.h"

@implementation VTitleAd
@synthesize _appListVC,_totalCount,_adArray;
@synthesize _conListDict;
@synthesize _page;
@synthesize _networkType;

@synthesize delegate;
@synthesize hasPage;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {	
	}
    return self;
}

-(void)asynInit{
	AdDownloader *adDownloader = [[[AdDownloader alloc] init] autorelease];
	[adDownloader getAdAppFromConList:self._conListDict];
	adDownloader.delegate = self;
}


-(void)addImageView{
	
	self.frame = CGRectMake(0, 0, 320 * self._page, ROW_HEIGHT);
	for(UIView *_v in self.subviews){
		if(_v)
			[_v removeFromSuperview];
			_v = nil;
	}
	for(int i = 0; i < [self._adArray count]; i++){
		MApp *app = [self._adArray objectAtIndex:i];
		
		logo = [[VFirstPageLogo alloc] initWithFrame:
										CGRectMake(32 + kLeftMargin + kTitleADSizeWidthHeight * (i % 3) + kDistanceBetween * (i % 3) + 320 * (i / 3), 11, 80, 76)];
		logo._appListVC = self._appListVC;
		logo._mad = app;
		logo._networkType = self._networkType;
		logo.tag = (i + 1) * 100;
		[logo bindItem];
		[self addSubview:logo];
		[logo release];
	}
	
    if(self.delegate != nil)
        [self.delegate titleAdViewLoadingOver];
}

-(void)getADApp:(NSMutableArray *)data{
	self._adArray = [NSMutableArray arrayWithArray:data];
	self._totalCount = [self._adArray count];
	self._page = (self._totalCount % 3 == 0) ? self._totalCount / 3 : (self._totalCount / 3 + 1);
	
	[self performSelectorOnMainThread:@selector(addImageView) withObject:nil waitUntilDone:YES];
}

- (void)dealloc {
	self._adArray = nil;
	[self._conListDict release];
	self._conListDict = nil;
	self._networkType = nil;
	
    [super dealloc];
}


@end
