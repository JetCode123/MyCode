//
//  MAd.h
//  TimeLimitedFree
//
//  Created by 聂 刚 on 11-5-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MAd : NSObject {
	NSString *name;
	NSString *logo;
	NSString *sourceURL;
	NSString *wifiLogo;
	NSString *wifiLogoCache;
	BOOL isTodayUpdate;
}
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *logo;
@property (nonatomic,retain) NSString *sourceURL;
@property (nonatomic,retain) NSString *wifiLogo;
@property (nonatomic,retain) NSString *wifiLogoCache;
@property BOOL isTodayUpdate;
@end
