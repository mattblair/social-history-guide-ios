//
//  KYCAppDelegate.h
//  knowYourCity
//
//  Created by Matt Blair on 1/9/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface KYCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navVC;
@property (strong, nonatomic) HomeViewController *homeViewController;

// Internet availability
- (BOOL)currentlyOnline;

@end
