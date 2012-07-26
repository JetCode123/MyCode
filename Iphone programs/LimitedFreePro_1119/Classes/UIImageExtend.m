//
//  UIImageExtend.m
//  AppNavigator
//
//  Created by meng Xiangping on 11-1-19.
//  Copyright 2011 盛拓传媒. All rights reserved.
//

#import "UIImageExtend.h"


@implementation UIImage (Shadow)

- (UIImage *)imageWithShadow {
	
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width + 2, self.size.height + 2, CGImageGetBitsPerComponent(self.CGImage), 0, 
													   colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
	
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(1, -3), 4, [UIColor darkGrayColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0.4, 3, self.size.width, self.size.height), self.CGImage);
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
	
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
	
    return shadowedImage;
}

@end
