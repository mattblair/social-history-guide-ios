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

@interface ThemeViewController : UIViewController <StoryStubDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, SHGMapViewDelegate>

@property (strong, nonatomic) NSDictionary *themeDictionary;

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType;

@end
