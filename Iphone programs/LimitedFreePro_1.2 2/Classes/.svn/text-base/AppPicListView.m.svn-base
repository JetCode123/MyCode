//
//  AppPicListView.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-9-1.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppPicListView.h"
#import "AppDetailsViewController.h"
#import "AppPicView.h"

@implementation AppPicListView
@synthesize application;
@synthesize detailController;
@synthesize imageDict;

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
	self.application = nil;
	self.detailController = nil;
	self.imageDict = nil;
	
    [super dealloc];
}

-(void)showImages{
	if(self.application._appIPhonePictureList != nil && [self.application._appIPhonePictureList count] > 0){
		self.imageDict = [NSMutableDictionary dictionary];
		for(int i = 0; i < [self.application._appIPhonePictureList count]; i++){
			CGRect frame = CGRectMake(0, 380 * i + 10 * i, 260, 380);
			// TODO:
			
			AppPicView *picView = [[AppPicView alloc] initWithFrame:frame];
			picView.index = i;
			picView.imageURL = [self.application._appIPhonePictureList objectAtIndex:i];
			picView.imageWidth = [[self.application._appIPhoneImgWidth objectAtIndex:i] intValue];
			picView.imageHeight = [[self.application._appIPhoneImgHeight objectAtIndex:i] intValue];
			picView.mainView = self;
			[picView showImage];
			
			[self addSubview:picView];
			[picView release];
		}
	}
}

@end
