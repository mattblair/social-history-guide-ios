//
//  ThemeViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryStubView.h"
#import "SHGMapView.h"

#import <MessageUI/MessageUI.h>

//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>

// Need to make these conditional on iOS 5+
// via http://stackoverflow.com/a/8601053

// probably don't need this for twitter anymore, but what about social frame work for FB in 6.0?

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#endif

@interface ThemeViewController : UIViewController <StoryStubDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, SHGMapViewDelegate>

// temporary, for prototyping pending Core Data
// will be replaced by an NSManagedObject subclass called Theme
@property (strong, nonatomic) NSDictionary *themeDictionary;

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType;

@end
