//
//  JSAppDelegate.m
//  Jansampark
//
//  Created by dev27 on 6/25/13.
//  Copyright (c) 2013 Grappus. All rights reserved.
//

#import "JSAppDelegate.h"
#import "JSAPIInterface.h"
#import "JSModel.h"
#import <KSReachability.h>
#import "Constants.h"
#import "TestFlight.h"
#import "JSAPIInteracter.h"

@implementation JSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  [JSAPIInterface sharedInterface];
  [[JSModel sharedModel] startTrackingLocation];
  
  [JSModel sharedModel].reachability = [KSReachability reachabilityToHost:nil];  
  NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:kUUIDKey];
  if(!UUID.length) {
    UUID = [[JSModel sharedModel] GetUUID];
    [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:kUUIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  [TestFlight takeOff:@"6436852a-dac3-4796-9772-58f948f3e106"];
  [[JSAPIInteracter shared] fetchYoutubeVideoURLs];
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [[JSModel sharedModel] stopTrackingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  [[JSModel sharedModel] startTrackingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
