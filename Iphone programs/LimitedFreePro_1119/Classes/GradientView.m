//
//  GradientView.m
//  LimitedFreePro
//
//  Created by lu jiaolong on 11-11-18.
//  Copyright (c) 2011年 SequelMedia. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//      init the gradient
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colors[] = {
            0.15, 0.15, 0.15, 255 / 255.0,
            0, 0, 0, 255 / 255.0,
            0, 0, 0, 255 / 255.0,
        };
        
        mGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 3);
        CGColorSpaceRelease(rgb);
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context;
    CGPoint start,end;
    
    context = UIGraphicsGetCurrentContext();
    start = CGPointMake(0, 0);
    end = start;
    end.y += [self frame].size.height;
    
    CGContextDrawLinearGradient(context, mGradient, start, end, 0);
    CGContextFillRect(context, self.frame);
}

- (void)dealloc{
    
    CGGradientRelease(mGradient);
    [super dealloc];
}

@end
