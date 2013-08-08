//
//  KYCConstants.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// Layout

#define DEFAULT_CONTENT_WIDTH 300.0
#define DEFAULT_LEFT_MARGIN 10.0

#define VERTICAL_SPACER_STANDARD 10.0
#define VERTICAL_SPACER_EXTRA 25.0

#define MAIN_PHOTO_WIDTH 320.0
#define MAIN_PHOTO_HEIGHT 240.0

// Tag offsets (probably temporary. UIView subclasses could store an identifier instead.
#define STORY_TAG_OFFSET 342938

// Media Type will determine layout and/or which view controllers to use to present content
// tidbits will use this too

// what about letters/ documents?
typedef NS_ENUM(NSUInteger, KYCStoryMediaType) {
    KYCStoryMediaTypeAudio = 0,       // default
    KYCStoryMediaTypeAudioText,
    KYCStoryMediaTypeText,
    KYCStoryMediaTypePhotoAndCaption, // not much text
    KYCStoryMediaTypePhotoAndText,    // 50 - 200 words of text
    KYCStoryMediaTypeBiography,       // a brief profile
    KYCStoryMediaTypeQuote,
    KYCStoryMediaTypeMapPoints,       // points only
    KYCStoryMediaTypeMapComplex,      // may include poly-lines and polygrams
    KYCStoryMediaTypeMapOverlay,      // geo-rectified image to display on map
    KYCStoryMediaTypeVideo            // not supported in v1.0, or until we have video
};

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
extern CGFloat const kSectionTitleFontSize;
extern NSString* const kBodyFontName;
extern CGFloat const kBodyFontSize;
extern NSString* const kPhotoCreditFontName;
extern CGFloat const kPhotoCreditFontSize;
extern NSString* const kItalicFontName;
extern CGFloat const kItalicFontSize;

// Placeholder Text (temporary)
extern NSString* const kPlaceholderTextWords36;
extern NSString* const kPlaceholderTextWords52;
extern NSString* const kPlaceholderTextWords69;
extern NSString* const kPlaceholderTextWords102;
extern NSString* const kPlaceholderTextWords204;