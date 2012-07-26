//
//  VNavBar.m
//  AppNavForIphone
//
//  Created by 聂 刚 on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VNavBar.h"


@implementation VNavBar

-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
//	CGContextRef context = UIGraphicsGetCurrentContext();
//    self.frame = CGRectMake(0,20, 320, 44);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, 320, 44),[UIImage imageNamed:@"top_beijing.png"].CGImage);
	
	UIImage *topImage = [UIImage imageNamed:@"top_beijing.png"];
	[topImage drawInRect:rect];
    
}

- (void)dealloc {
    [super dealloc];
}

@end
