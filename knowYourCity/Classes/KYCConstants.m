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

// Off-device media
NSString* const kPhotosURL = @"http://kycstatic.elsewiseapps.com/photos/";
NSString* const kAudioURL = @"http://kycstatic.elsewiseapps.com/audio/";

// Home
NSString* const kMapButtonImage = @"kbb-map";
NSString* const kInfoButtonLightImage = @"kbb-info-light";
NSString* const kInfoButtonDarkImage = @"kbb-info-dark";

// Map View
NSString* const kThemeListButtonImage = @"kbb-list";
NSString* const kLocationButtonImage = @"kbb-location-filled";

// Map-related
NSString* const kMapPinButtonImage = @"kbb-map-pin";
NSString* const kRefreshButtonImage = @""; // not used?


NSString* const kCloseButton = @"kbb-x-2";
NSString* const kActionButton = @"kbb-action-2";
NSString* const kBackButtonImage = @"";

NSString* const kAppNameImage = @"pshg-title";


// Nav Toolbar -- deprecated?
NSString* const kNavAppLogoiPad = @"";

#warning These graphics have been removed
NSString* const kNavAppLogoiPhone = @"logo_header_black";
NSString* const kNavBarBackgroundiPhone = @"kycNavBarBlack";


// Audio Player Images
NSString* const kPlayButtonImage = @"kbb-play";
NSString* const kPauseButtonImage = @"kbb-pause";
NSString* const kThumbButtonImage = @"kbb-audio-thumb";
NSString* const kMinimumTrackImage = @"kbb-slider-2-filled"; // i.e. played
NSString* const kMaximumTrackImage = @"kbb-slider-2-empty"; // i.e. yet to be played


// Image Defaults

NSString* const kDetailBackgroundImageiPad = @"";
NSString* const kDetailBackgroundImageiPhone = @"";

// Contact Information
NSString* const kAppWebsiteURL = @"http://pdxsocialhistory.org/app";
NSString* const kWebMapURL = @"http://pdxsocialhistory.org";
NSString* const kEmailFooter = @"\n\n\n-----\nSent via the Portland Social History Guide app\nFor more info, visit: http://pdxsocialhistory.org";
NSString* const kFeedbackEmailAddress = @"feedback@pdxsocialhistory.org";
NSString* const kSubmissionEmailAddress = @"support@pdxsocialhistory.org";

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


NSString* const kTitleFontName = @"Futura-Medium"; //
CGFloat const kTitleFontSize = 24.0;
CGFloat const kSectionTitleFontSize = 18.0;
NSString* const kBodyFontName = @"AvenirNext-Regular";
CGFloat const kBodyFontSize = 14.0;
NSString* const kPhotoCreditFontName = @"AvenirNext-UltraLightItalic";
CGFloat const kPhotoCreditFontSize = 12.0;
NSString* const kItalicFontName = @"Futura-Medium"; // should probably match line Font
CGFloat const kItalicFontSize = 12.0;

// Placeholder Text (temporary)
NSString* const kPlaceholderTextWords36 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
NSString* const kPlaceholderTextWords52 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords69 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
NSString* const kPlaceholderTextWords102 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords204 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";

