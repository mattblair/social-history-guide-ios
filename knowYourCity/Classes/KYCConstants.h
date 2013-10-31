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
#define VERTICAL_SPACER_EXTRA 20.0 // was 25.0

#define MAIN_PHOTO_WIDTH 320.0
#define MAIN_PHOTO_HEIGHT 240.0

// Media Type will determine layout and/or which view controllers to use to present content
// flashbacks will use this, too.

// this maps to the media_types table of the Rails site
typedef NS_ENUM(NSUInteger, KYCStoryMediaType) {
    KYCStoryMediaTypeUnused = 0,        // Rails tables are 1-indexed
    KYCStoryMediaTypePhotoInterview,    // default
    KYCStoryMediaTypeMapInterview,
    KYCStoryMediaTypeInterviewOnly,
    KYCStoryMediaTypeAmbientAudio,
    KYCStoryMediaTypeTextOnly,
    KYCStoryMediaTypeTextWithPhoto,
    KYCStoryMediaTypePhotoGallery,
    KYCStoryMediaTypeGeoJSONMap,        // only points in 1.0. May include poly-lines and polygrams in future.
    KYCStoryMediaTypeNoMedia
};

// probably only used for import filtering. Even then, maybe only for testing.
typedef NS_ENUM(NSUInteger, KYCWorkflowState) {
    KYCWorkflowStateProposed = 0,
    KYCWorkflowStateDraft,
    KYCWorkflowStateDeferred,
    KYCWorkflowStateIncomplete,
    KYCWorkflowStateEdited,
    KYCWorkflowStatePublished,
    KYCWorkflowStateTesting
};

// Off-device images
extern NSString* const kPhotosURL;
extern NSString* const kAudioURL;

// Home
extern NSString* const kMapButtonImage;
extern NSString* const kInfoButtonLightImage;
extern NSString* const kInfoButtonDarkImage;

// Map View
extern NSString* const kThemeListButtonImage;
extern NSString* const kLocationButtonImage;

// Map-related
extern NSString* const kMapPinButtonImage;
extern NSString* const kRefreshButtonImage; // not used?

extern NSString* const kCloseButton;
extern NSString* const kActionButton;
extern NSString* const kBackButtonImage;

extern NSString* const kAppNameImage;

// Nav Buttons
extern NSString* const kNavAppLogoiPad;
extern NSString* const kNavAppLogoiPhone;
extern NSString* const kNavBarBackgroundiPhone;


// Audio Player Images
extern NSString* const kPlayButtonImage;
extern NSString* const kPauseButtonImage;
extern NSString* const kThumbButtonImage; // UISlider
extern NSString* const kMinimumTrackImage; // UISlider
extern NSString* const kMaximumTrackImage; // UISlider

// Image Defaults

extern NSString* const kDetailBackgroundImageiPad;
extern NSString* const kDetailBackgroundImageiPhone;

// URLs, social sharing & contact information
extern NSString* const kProjectName;
extern NSString* const kProjectURL;
extern NSString* const kThemeURL;
extern NSString* const kStoryURL;
extern NSString* const kAppWebsiteURL;
extern NSString* const kAppHashTag;
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

// Flurry
extern NSString* const kFlurryEventThemeView;
extern NSString* const kFlurryEventThemeShare;
extern NSString* const kFlurryEventStoryView;
extern NSString* const kFlurryEventStoryViewFromMap;
extern NSString* const kFlurryEventStoryShare;
extern NSString* const kFlurryEventGuestView;
extern NSString* const kFlurryEventPageView;
extern NSString* const kFlurryParamSlug;
extern NSString* const kFlurryParamActivity;

// Placeholder Text (temporary)
extern NSString* const kPlaceholderTextWords36;
extern NSString* const kPlaceholderTextWords52;
extern NSString* const kPlaceholderTextWords69;
extern NSString* const kPlaceholderTextWords102;
extern NSString* const kPlaceholderTextWords204;