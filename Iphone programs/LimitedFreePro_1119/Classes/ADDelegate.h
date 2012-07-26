//
//  ADDelegate.h
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAd.h"

@interface ADDelegate : NSObject<NSXMLParserDelegate> {
	NSMutableArray *data;
	NSInteger totalCount;
	MAd *currentApp;
	NSMutableString *tempString;
	
	bool inAppInfo;
}
@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) MAd *currentApp;
@property (nonatomic,retain) NSMutableString *tempString;
@property (nonatomic) NSInteger totalCount;
@end
