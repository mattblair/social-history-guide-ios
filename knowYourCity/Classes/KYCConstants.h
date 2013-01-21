//
//  KYCConstants.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// Core Data

// EWCoreDataManager Configuration
extern NSString* const kEWCoreDataModelName;
extern NSString* const kEWCoreDataDatabaseFilenameInBundle;
extern NSString* const kEWCoreDataDatabaseFilenameOnDisk;
extern NSString* const kEWCoreDataDatabaseInLibrarySubdirectory;
extern BOOL const kEWCoreDataBlockDatabaseFromiCloudBackup;
extern BOOL const kEWCoreDataReplaceDatabase;

// JSON Files
extern NSString* const kSeedJSONFilename;
extern NSString* const kLiveJSONURI;

// Toolbar
extern NSString* const kMapButtonImage;
extern NSString* const kTidbitButtonImage;
extern NSString* const kInfoButtonImage;
extern NSString* const kTimelineButtonImage;

// Map Toolbar
extern NSString* const kLocationButtonImage;
extern NSString* const kRegionSelectButtonImage;
extern NSString* const kRefreshButtonImage;

// Nav Buttons
extern NSString* const kNavAppLogoiPad;
extern NSString* const kNavAppLogoiPhone;
extern NSString* const kNavBarBackgroundiPhone;
extern NSString* const kBackButtonImage;

// Audio Player Images
extern NSString* const kPlayButtonImage;
extern NSString* const kPauseButtonImage;
extern NSString* const kThumbButtonImage; // UISlider
extern NSString* const kMinimumTrackImage; // UISlider
extern NSString* const kMaximumTrackImage; // UISlider

// Sharing Buttons
extern NSString* const kEmailButtonImage;
extern NSString* const kTweetButtonImage;
extern NSString* const kFacebookButtonImage;
extern NSString* const kFeedbackButtonImage;

extern NSString* const kCameraButtonImage;
extern NSString* const kCloseButtonImage;

// Image Defaults

extern NSString* const kDetailBackgroundImageiPad;
extern NSString* const kDetailBackgroundImageiPhone;

// Contact Information
extern NSString* const kAppWebsiteURL;
extern NSString* const kWebMapURL;
extern NSString* const kEmailFooter;
extern NSString* const kFeedbackEmailAddress;
extern NSString* const kSubmissionEmailAddress;

// Notifications
extern NSString* const kCurrentLocationAvailableNotification;
extern NSString* const kCurrentLocationFailureNotification;
extern NSString* const kMapDataRefreshNeededNotification;
extern NSString* const kFullScreenCameraRequestedNotification;

// Fonts
extern NSString* const kTitleFontName;
extern CGFloat const kTitleFontSize;
extern NSString* const kBodyFontName;
extern CGFloat const kBodyFontSize;
extern NSString* const kPhotoCreditFontName;
extern CGFloat const kPhotoCreditFontSize;
extern NSString* const kItalicFontName;
extern CGFloat const kItalicFontSize;
