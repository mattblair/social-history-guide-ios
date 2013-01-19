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
NSString* const kSeedJSONFilename = @"kyc-data"; // will usually have a date code appended
NSString* const kLiveJSONURI = @"TBD";

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
NSString* const kNavAppLogoiPhone = @"";
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
// Example usage:
// <some font property> = [UIFont fontWithName:kLineFontName size:kLineFontSize];

NSString* const kTitleFontName = @"Baskerville-Bold";
CGFloat const kTitleFontSize = 16.0;
NSString* const kBodyFontName = @"Baskerville";
CGFloat const kBodyFontSize = 16.0;
NSString* const kPhotoCreditFontName = @"Baskerville-Italic";
CGFloat const kPhotoCreditFontSize = 12.0;
NSString* const kItalicFontName = @"Baskerville-SemiBoldItalic"; // should probably match line Font
CGFloat const kItalicFontSize = 12.0;
