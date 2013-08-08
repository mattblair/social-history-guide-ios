//
//  KYCConstants.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "KYCConstants.h"

// EWCoreDataManager Configuration
NSString* const kEWCoreDataModelName = @"knowyourcity"; // momd will be appended
NSString* const kEWCoreDataDatabaseFilenameInBundle = @"knowyourcityTBD.sqlite";
NSString* const kEWCoreDataDatabaseFilenameOnDisk = @"knowyourcityTBD.sqlite.sqlite";
NSString* const kEWCoreDataDatabaseInLibrarySubdirectory = @""; // will default to /Documents
BOOL const kEWCoreDataBlockDatabaseFromiCloudBackup = NO;
// typically NO when shipping, YES while testing and sending beta builds with refreshed data
BOOL const kEWCoreDataReplaceDatabase = YES;


// JSON
NSString* const kSeedJSONFilename = @"kyc-demo-130527"; // kyc-data will usually have a date code appended
NSString* const kLiveJSONURI = @"TBD";

// Off-device images
NSString* const kPhotosURL = @"http://kycstatic.elsewiseapps.com/photos/";

// Toolbar
NSString* const kMapButtonImage = @"59-info-smaller";
NSString* const kTidbitButtonImage = @"59-info-smaller";
NSString* const kInfoButtonImage = @"59-info-smaller"; // @"42-info";
NSString* const kTimelineButtonImage = @"59-info-smaller";

// Map Toolbar
NSString* const kLocationButtonImage = @"74-location";
NSString* const kRegionSelectButtonImage = @"103-map";
NSString* const kRefreshButtonImage = @"01-refresh";

// Nav Toolbar
NSString* const kNavAppLogoiPad = @"";
NSString* const kNavAppLogoiPhone = @"logo_header_black";
NSString* const kNavBarBackgroundiPhone = @"kycNavBarBlack";
NSString* const kBackButtonImage = @"";

// Audio Player Images
NSString* const kPlayButtonImage = @"";
NSString* const kPauseButtonImage = @"";
NSString* const kThumbButtonImage = @""; // UISlider
NSString* const kMinimumTrackImage = @""; // UISlider
NSString* const kMaximumTrackImage = @""; // UISlider


// Other Buttons
NSString* const kEmailButtonImage = @"18-envelope"; // or standard email/compose
NSString* const kTweetButtonImage = @"210-twitterbird";
NSString* const kFacebookButtonImage = @"208-facebook";
NSString* const kFeedbackButtonImage = @"09-chat-2";
NSString* const kCameraButtonImage = @"168-upload-photo-2";
NSString* const kCloseButtonImage = @"298-circlex"; // or 37-circle-x

// Image Defaults

NSString* const kDetailBackgroundImageiPad = @"";
NSString* const kDetailBackgroundImageiPhone = @"";

// Contact Information
NSString* const kAppWebsiteURL = @"http://knowyourcity.org";
NSString* const kWebMapURL = @"http://knowyourcity.org";
NSString* const kEmailFooter = @"\n\n\n-----\nSent via the Know Your City app\nFor more info, visit: http://knowyourcity.org";
NSString* const kFeedbackEmailAddress = @"feedback@knowyourcity.org";
NSString* const kSubmissionEmailAddress = @"submit@knowyourcity.org";

// Notifications
NSString* const kCurrentLocationAvailableNotification = @"kCurrentLocationAvailableNotification";
NSString* const kCurrentLocationFailureNotification = @"kCurrentLocationFailureNotification";
NSString* const kMapDataRefreshNeededNotification = @"kMapDataRefreshNeededNotification";
NSString* const kFullScreenCameraRequestedNotification = @"kFullScreenCameraRequestedNotification";

// Fonts

// Options to consider:
// Georgia-Bold, Georgia-Italic, Georgia
// Palatino-Roman, Palatino-Italic Palatino-Bold Palatino-BoldItalic
// Baskerville | Baskerville-Bold | Baskerville-Italic | Baskerville-SemiBoldItalic
// Example usage:
// <some font property> = [UIFont fontWithName:kLineFontName size:kLineFontSize];
// AmericanTypewriter | AmericanTypewriter-Bold | AmericanTypewriter-Light


NSString* const kTitleFontName = @"Baskerville-Bold"; //
CGFloat const kTitleFontSize = 28.0;
CGFloat const kSectionTitleFontSize = 22.0;
NSString* const kBodyFontName = @"Baskerville";
CGFloat const kBodyFontSize = 14.0;
NSString* const kPhotoCreditFontName = @"Georgia-Italic";
CGFloat const kPhotoCreditFontSize = 12.0;
NSString* const kItalicFontName = @"Futura-MediumItalic"; // should probably match line Font
CGFloat const kItalicFontSize = 12.0;

// Placeholder Text (temporary)
NSString* const kPlaceholderTextWords36 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
NSString* const kPlaceholderTextWords52 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords69 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
NSString* const kPlaceholderTextWords102 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords204 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";

