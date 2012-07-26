//
//  NSString+URLEncoding.m
//  weibo4objc
//
//  Created by fanng yuan on 3/11/11.
//  Copyright 2011 fanngyuan@sina. All rights reserved.
//

#import "NSString+URLEncoding.h"
#import "escape.h"

@implementation NSString (OAURLEncodingAdditions)

/*- (NSString *)URLEncodedString 
{
	char * selfBeforeEscape = [self UTF8String];	
	char * selfAfterEscape = urlEscape(selfBeforeEscape, strlen(selfBeforeEscape));
	NSString * result = [NSString stringWithUTF8String:selfAfterEscape];
	free(selfAfterEscape);
	return result;
}

- (NSString*)URLDecodedString
{
	char * selfBeforUnescape = [self UTF8String];
	int * outputSize ;
	char * selfAfterUnescape = urlUnescape(selfBeforUnescape, strlen(selfBeforUnescape), outputSize);
	NSString * result = [NSString stringWithUTF8String:selfAfterUnescape];
	free(selfAfterUnescape);	
	return result;	
}
*/

- (NSString *)URLEncodedString 
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
}

@end
