//
//  AppListBasedCell.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-25.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppListBasedCell.h"
#import "AppListCellView.h"
#import "Contants.h"

@implementation AppListBasedCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier];
	if(self){
		self._cellContentView = [[AppListCellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ROW_HEIGHT) andCell:self];
		
		[self.contentView  addSubview:self._cellContentView];
		[self._cellContentView release];
	}
	return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
	[super setBackgroundColor:backgroundColor];
	self._cellContentView.backgroundColor = backgroundColor;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)dealloc{

	[super dealloc];
}

@end
