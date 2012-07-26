//
//  TimeLimitFreeAppDelegate.h
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-23.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "Reachability.h"

@interface TimeLimitFreeAppDelegate : NSObject <UIApplicationDelegate,MobClickDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	Reachability *_hostReach,*_internetReach;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic,retain) Reachability *_hostReach;
@property (nonatomic,retain) Reachability *_internetReach;

-(void)updateWithReachability:(Reachability *)curReach;
-(void)configureAlert:(Reachability *)curReach;

@end

