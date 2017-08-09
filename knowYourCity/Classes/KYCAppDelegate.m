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

#import <Reachability/Reachability.h>

#import "EWAMapManager.h"

#import "KYCPrivateConstants.h"
#import "HomeViewController.h"

@interface KYCAppDelegate ()

@property (strong, nonatomic) Reachability *internetReach;

@end


@implementation KYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    
    
    // Configure audio session
    NSError *audioSessionError = nil;
    
    // this configuration overrides the mute switch, and allows playback along with other sources, like music
    BOOL audioSessionSuccess = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                                withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                                                      error:&audioSessionError];
    
    if (!audioSessionSuccess) {
        
        DLog(@"Error setting audio session: %@ with info: %@", audioSessionError, [audioSessionError userInfo]);
    }
    
    /*
    // only start Flurry if the API Key is defined
    if (kFlurryAPIKey) {
        
        [Flurry startSession:kFlurryAPIKey];
    }
    */
    
    [self setupReachability];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // make sure location starts so we have location when we need it
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

#pragma mark - UI Customization

- (void)configureAppearance {
    
    // set default color for all active controls
    self.window.tintColor = [UIColor kycRed];
    /*
    if (ON_IOS7) {
        
        // set default color for all active controls
        self.window.tintColor = [UIColor kycRed];
        
    } else { // iOS 6.x -- keep using UIAppearance
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor : [UIColor blackColor],
                                                           UITextAttributeTextShadowColor : [UIColor kycLightGray],
                                                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.5, 0.5)],
                                                           UITextAttributeFont : [UIFont fontWithName:kTitleFontName
                                                                                                 size:kSectionTitleFontSize]
                                                           }];
        
        // Hack to prevent border on bar buttons.
        // Alternative: use initWithCustomView with UIImageView for each button.
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        
        // This is tough to resize precisely because of non-parallel lines
        UIImage *backButtonImage = [[UIImage imageNamed:kBackButtonImage] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 25.0, 1.0, 20.0)];
        //UIImage *backButtonImage = [UIImage imageNamed:kBackButtonImage];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        
        // shadows look bad on this...
        // kBodyFontName @ 13.0 looks best with standard UIKit back button
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor kycRed],
                                                                UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)],
                                                                UITextAttributeFont : [UIFont fontWithName:kTitleFontName
                                                                                                      size:15.0]}
                                                    forState:UIControlStateNormal];
    }
    */
}

#pragma mark - Reachability Management

- (void)setupReachability {
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    
    // returns a BOOL that could be tested/logged
    [self.internetReach startNotifier];
}

- (BOOL)currentlyOnline {
    
    // could also use isReachableViaWiFi or isReachableViaWWAN for more control
	return [self.internetReach isReachable];
}

- (void)warnAboutOfflineMaps {
    
    DLog(@"");
}

- (void)warnAboutOfflinePhotos {
    
    // could turn this into an integer if we wanted to warn occasionally
    BOOL warned = [[NSUserDefaults standardUserDefaults] boolForKey:kOfflinePhotosWarningKey];
    
    if (!warned) {
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Photos Unavailable Offline"
                                                               message:@"An internet connection is required to display photos"
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"OK", nil];
        
        [warningAlert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kOfflinePhotosWarningKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
