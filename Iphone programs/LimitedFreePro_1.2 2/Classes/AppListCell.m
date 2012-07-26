//
//  AppListCell.m
//  LimitedFreePro
//
//  Created by lujiaolong on 11-11-10.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "AppListCell.h"


@implementation AppListCell

@synthesize _iconImgView;
@synthesize _iconMaskImgView;
@synthesize _app;
@synthesize _orderIndex;
@synthesize _cellContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		
		UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 66, 66)];
		icon.image = [UIImage imageNamed:@"mask_dark_y.png"];
		self._iconMaskImgView = icon;
		[self addSubview:self._iconMaskImgView];
		[icon release];
	
		self._iconImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 66, 66)] autorelease];
		[self addSubview:self._iconImgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	
	[_iconImgView release];
	[_iconMaskImgView release];
	[_app release];
	[_cellContentView release];
	
    [super dealloc];
}


@end
