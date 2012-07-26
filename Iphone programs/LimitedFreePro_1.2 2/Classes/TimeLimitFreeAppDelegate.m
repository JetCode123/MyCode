//
//  TimeLimitFreeAppDelegate.m
//  TimeLimitFree
//
//  Created by lujiaolong on 11-8-23.
//  Copyright 2011 SequelMedia. All rights reserved.
//

#import "TimeLimitFreeAppDelegate.h"
#import "RootViewController.h"
#import "Contants.h"
#import "ImageCache.h"

#define EXIT_TIME @"exit-time"
#define REMOVE_CACHE_TIME @"remove-cache-time"
#define kCacheTimeInterval -7200
@implementation TimeLimitFreeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize _hostReach;
@synthesize _internetReach;

#pragma mark -
#pragma mark Application lifecycle

-(NSString *)appKey{
	return @"4e798c1552701508f2000003";
	//return @"4e536fa6431fe37c7d0001c0";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    

	
	_internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[_internetReach startNotifier];
	
	[self updateWithReachability:_internetReach];
	
	// Set the navigation controller as the window's root view controller and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	

	[MobClick setDelegate:self];
	[MobClick appLaunched];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    return YES;
}

// 1.
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
	[MobClick appTerminated];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:EXIT_TIME];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)removeCache{
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:REMOVE_CACHE_TIME];
	[ImageCache checkCache];
    
//    NSDate *removeCacheDate = [[NSUserDefaults standardUserDefaults] objectForKey:REMOVE_CACHE_TIME];
//    NSLog(@"remove-cache-time = %@",removeCacheDate);
}

// 2.
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

// 3.
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	[MobClick setDelegate:self];
	[MobClick appLaunched];
}

// 4.
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSDate *exitDate = [[NSUserDefaults standardUserDefaults] objectForKey:EXIT_TIME];
	if(exitDate != nil && [exitDate timeIntervalSinceNow] < kCacheTimeInterval){
		
		RootViewController *_rootVC = (RootViewController *)[self.navigationController.viewControllers objectAtIndex:0];
		
		NSInteger count = [self.navigationController.viewControllers count];
		if(count > 1){
			for(int i = 1; i < count;i ++){
				
				[self.navigationController popViewControllerAnimated:YES];
			}
		}
		[_rootVC._conListDict setValue:@"New" forKey:KEY_ORDER];
		[_rootVC._conListDict setValue:[NSNumber numberWithInt:24] forKey:KEY_CATEGORYID];
		
		UIButton *titleBtn = (UIButton *)_rootVC.navigationItem.titleView;
		[titleBtn setTitle:@"最新排行" forState:UIControlStateNormal];
		
		[_rootVC clickReload];
		[_rootVC drawBack];
	}
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:EXIT_TIME];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *inv = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(removeCache) object:nil];
    [queue addOperation:inv];
    [inv release];
    [queue release];


}

// 5.
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[MobClick appTerminated];
    
}

-(void)reachabilityChanged:(NSNotification *)note{
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateWithReachability:curReach];
}

-(void)updateWithReachability:(Reachability *)curReach{
	[self configureAlert:curReach];
}

-(void)configureAlert:(Reachability *)curReach{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch(netStatus){
		case NotReachable:{
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:Key_HaveNetwork];
			
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_NOTIFICATION object:nil];
			break;
		}
		case ReachableViaWWAN:{
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:Key_HaveNetwork];
			[[NSUserDefaults standardUserDefaults] setValue:@"3g" forKey:Key_NetworkType];
			
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_NOTIFICATION object:nil];
			break;
		}
		case ReachableViaWiFi:{
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:Key_HaveNetwork];
			[[NSUserDefaults standardUserDefaults] setValue:@"Wifi" forKey:Key_NetworkType];
			
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_NOTIFICATION object:nil];
			break;
		}
		default:
			break;
	}
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
	
	[self._hostReach release];
	self._hostReach = nil;
	
	[self._internetReach release];
	self._internetReach = nil;
	
	[super dealloc];
}

@end

