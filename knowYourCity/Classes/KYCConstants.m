//
//  KYCConstants.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "KYCConstants.h"

NSString* const kAppStoreBundleID = @"com.elsewiseapps.pdxshg";

// Off-device media
//NSString* const kPhotosURL = @"http://kycstatic.elsewiseapps.com/photos/";
NSString* const kPhotosURL = @"https://s3-us-west-2.amazonaws.com/pdxshg.media/photos/";

// hand on to this for 1.1+
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

NSString* const kCloseButton = @"kbb-x-1"; // kbb-x-2
NSString* const kActionButton = @"kbb-action-2";
NSString* const kBackButtonImage = @"kbb-back"; // iOS 6 only

NSString* const kPhotoPlaceholderImage = @"pshg-photo-placeholder";
NSString* const kOfflinePhotoPlaceholderImage = @"pshg-photo-offline-placeholder";

NSString* const kAppNameImage = @"pshg-title";

// Audio Player Images
NSString* const kPlayButtonImage = @"kbb-play";
NSString* const kPauseButtonImage = @"kbb-pause";
NSString* const kThumbButtonImage = @"kbb-audio-thumb";
NSString* const kMinimumTrackImage = @"kbb-slider-2-filled"; // i.e. played
NSString* const kMaximumTrackImage = @"kbb-slider-2-empty"; // i.e. yet to be played


// URLs, social sharing & contact information
NSString* const kProjectName = @"PDX Social History Guide";
NSString* const kProjectURL = @"http://pdxsocialhistory.org";
NSString* const kThemeURL = @"http://pdxsocialhistory.org/themes";
NSString* const kStoryURL = @"http://pdxsocialhistory.org/stories";
NSString* const kAppWebsiteURL = @"http://pdxsocialhistory.org/app";
NSString* const kAppHashTag = @"PDXSocialHistory";
NSString* const kEmailFooter = @"\n\n\n-----\nSent via the Portland Social History Guide app\nFor more info, visit: http://pdxsocialhistory.org";
NSString* const kFeedbackEmailAddress = @"feedback@pdxsocialhistory.org";
NSString* const kSubmissionEmailAddress = @"support@pdxsocialhistory.org";

// Notifications
NSString* const kCurrentLocationAvailableNotification = @"kCurrentLocationAvailableNotification";
NSString* const kCurrentLocationFailureNotification = @"kCurrentLocationFailureNotification";
NSString* const kMapDataRefreshNeededNotification = @"kMapDataRefreshNeededNotification";
NSString* const kFullScreenCameraRequestedNotification = @"kFullScreenCameraRequestedNotification";

// User Defaults
NSString* const kOfflineMapsWarningKey = @"kOfflineMapsWarningKey";
NSString* const kOfflinePhotosWarningKey = @"kOfflinePhotosWarningKey";

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

// Flurry
NSString* const kFlurryEventThemeView = @"ThemeView";
NSString* const kFlurryEventThemeShare = @"ThemeShare";
NSString* const kFlurryEventStoryView = @"StoryView";
NSString* const kFlurryEventStoryViewFromMap = @"StoryViewFromMap";
NSString* const kFlurryEventStoryShare = @"StoryShare";
NSString* const kFlurryEventGuestView = @"GuestView";
NSString* const kFlurryEventPageView = @"PageView";
NSString* const kFlurryParamSlug = @"slug";
NSString* const kFlurryParamActivity = @"activity";

// Placeholder Text (temporary)
NSString* const kPlaceholderTextWords36 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
NSString* const kPlaceholderTextWords52 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords69 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
NSString* const kPlaceholderTextWords102 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
NSString* const kPlaceholderTextWords204 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";

