//
//  VIndicator.m
//  限时免费_me
//
//  Created by lujiaolong on 11-9-13.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "VIndicator.h"

#define PAGE_COUNT 2

@implementation VIndicator

// width = 160 height = 30.

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		for(int i = 0; i < PAGE_COUNT; i++){
			UIImageView *_imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_dot.png"]];
			_imgV.tag = i;
			_imgV.frame = CGRectMake((160 - 20) / 2 + 20 * i, 9, 12, 12);
			[self addSubview:_imgV];
			[_imgV release];
		}
        // Initialization code.
    }
    return self;
}


-(void)setSelected:(int)index{
	
	for(UIImageView *_imgV in self.subviews){
		if(_imgV){
			if(_imgV.tag == index){
				_imgV.image = [UIImage imageNamed:@"home_dot_selected.png"];
			}
			
			else
				_imgV.image = [UIImage imageNamed:@"home_dot.png"];
		}	
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
    [super dealloc];
}


@end
