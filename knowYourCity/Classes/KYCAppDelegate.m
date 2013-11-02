//
//  KYCAppDelegate.m
//  knowYourCity
//
//  Created by Matt Blair on 1/9/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "KYCAppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "EWAMapManager.h"

#import "KYCPrivateConstants.h"
#import "HomeViewController.h"


@implementation KYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    DLog(@"iOS Version is: %@", ON_IOS7 ? @"7+" : @"< 7");
    
    // Configure audio session
    NSError *audioSessionError = nil;
    
    // this configuration overrides the mute switch, and allows playback along with other sources, like music
    BOOL audioSessionSuccess = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                                withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                                                      error:&audioSessionError];
    
    if (!audioSessionSuccess) {
        
        DLog(@"Error setting audio session: %@ with info: %@", audioSessionError, [audioSessionError userInfo]);
    }
    
    [TestFlight takeOff:kTestFlightAppToken];
    
    [Flurry startSession:kFlurryAPIKey];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // make sure location starts so we ahve location when we need it
    [EWA_MM startup];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self configureAppearance];
    
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
    
    if (ON_IOS7) {
        
        // set default color for all active controls
        self.window.tintColor = [UIColor kycRed];
        
    } else { // iOS 6.x -- keep using UIAppearance?
        
        // was black -- or make this gray?
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor : [UIColor blackColor],
                                                           UITextAttributeTextShadowColor : [UIColor kycLightGray],
                                                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.5, 0.5)],
                                                           UITextAttributeFont : [UIFont fontWithName:kTitleFontName
                                                                                                size:kTitleFontSize]
                                                           }];
        
        // hack to prevent border on bar buttons:
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
        // this breaks the back button
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage alloc] init]
//                                                          forState:UIControlStateNormal
//                                                        barMetrics:UIBarMetricsDefault];
        
        // shadows look bad on this...
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor kycRed],
                                                                UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)],
                                                                UITextAttributeFont : [UIFont fontWithName:kBodyFontName
                                                                                                      size:13.0]}
                                                    forState:UIControlStateNormal];
    }
}

@end
