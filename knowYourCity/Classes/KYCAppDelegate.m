//
//  KYCAppDelegate.m
//  knowYourCity
//
//  Created by Matt Blair on 1/9/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "KYCAppDelegate.h"

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "KYCPrivateConstants.h"
#import "HomeViewController.h"

@implementation KYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[TestFlight takeOff:kTestFlightTeamToken];
    [TestFlight takeOff:kTestFlightAppToken];
    
    [Flurry startSession:kFlurryAPIKey];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [self configureAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // set default color in iOS 7
    self.window.tintColor = [UIColor kycRed];
    
    self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    
    self.navVC = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    self.window.rootViewController = self.navVC;
    [self.window makeKeyAndVisible];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configureAppearance {
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    // to use the same nav background for all view controllers
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:kNavBarBackgroundiPhone]
    //                                   forBarMetrics:UIBarMetricsDefault];
}

@end
