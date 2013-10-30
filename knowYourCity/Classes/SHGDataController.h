//
//  SHGDataController.h
//  knowYourCity
//
//  Created by Matt Blair on 10/14/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//


// At least in the first version:
// Read from a cleaned up archive of the database from the Rails site.
// In the future: could read from API, or fetched JSON, and persist to Core Data.
// That might be overkill, since this is a relatively static, read-only dataset.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

// temporary -- will be 6
#define PUBLISHED_WORKFLOW_STATE 2

typedef NS_ENUM(NSUInteger, SHGSearchResultType) {
    SHGSearchResultTypeTheme = 0,
    SHGSearchResultTypeStory,
    SHGSearchResultTypeFlashback,
    SHGSearchResultTypeStoryFlashback
};

// Cross-table keys

#define kContentIDKey @"id"
#define kContentTitleKey @"title"
#define kContentSubtitleKey @"subtitle"
#define kContentSlugKey @"slug"
#define kContentDisplayOrderKey @"display_order"

#define kContentLocationValidKey @"location_valid"
#define kContentLatitudeKey @"latitude"
#define kContentLongitudeKey @"longitude"
#define kContentZoomLevelKey @"zoom_level"

#define kContentMediaTypeKey @"media_type_id"

#define kContentAudioFilenameKey @"audio_filename"

#define kContentImageUsageClearedKey @"image_usage_cleared"
#define kContentImageStatusIDKey @"image_status_id"

#define kContentImageCaptionKey @"image_caption"

#define kContentImageCreditKey @"image_credit"
#define kContentImageCreditURLKey @"image_credit_url"
#define kContentImageCopyrightNoticeKey @"image_copyright_notice"
#define kContentImageCopyrightURLKey @"image_copyright_url"

#define kContentMapDataKey @"map_data"
#define kContentMapDataTypeKey @"map_data_type"

#define kContentMoreInfoURLKey @"more_info_url"
#define kContentMoreInfoTitleKey @"more_info_title"
#define kContentMoreInfoDescriptionKey @"more_info_description"

// Theme keys
#define kThemeIDKey @"id"
#define kThemeSummaryKey @"summary"
#define kThemeImageKey @"image_name"

// Story keys
#define kStoryIDKey @"id"
#define kStorySummaryKey @"summary"
#define kStoryImageKey @"image_name"
#define kStoryGuestIDKey @"guest_id"

// future: story keys for which data is currently incomplete:

// audio_transcription
// keywords
// thumbnail_name
// twitter_template

// Guest keys
#define kGuestIDKey @"id"
#define kGuestNameKey @"name"
#define kGuestTitleKey @"title"
#define kGuestOrganizationKey @"organization"
#define kGuestImageKey @"image_name"
#define kGuestBiographyKey @"bio"
#define kGuestQuoteKey @"quote"
#define kGuestURLKey @"guest_url"
#define kGuestURLTextKey @"guest_url_text"
#define kGuestSpecialtyKey @"specialty"

@interface SHGDataController : NSObject

// returns dictionaries
@property (strong, nonatomic) NSArray *publishedThemes;

+ (SHGDataController *)sharedInstance;


// Themes



// Stories

- (NSArray *)storiesForThemeID:(NSUInteger)themeID;

- (NSArray *)storyMapAnnotationsForThemeID:(NSUInteger)themeID;

- (NSArray *)mapAnnotationsOfType:(SHGSearchResultType)resultType inRegion:(MKCoordinateRegion)region maxCount:(NSUInteger)maxCount;

- (NSDictionary *)dictionaryForStoryID:(NSUInteger)storyID;

// Guests

- (NSDictionary *)dictionaryForGuestID:(NSUInteger)guestID;

// URLs

- (NSURL *)urlForPhotoNamed:(NSString *)photoName;
- (UIImage *)photoPlaceholder;

// probably won't be used in v1.0
- (NSURL *)urlForAudiofileNamed:(NSString *)audiofile;

// Utilities

- (CLLocationCoordinate2D)coordinateFromDictionary:(NSDictionary *)contentDictionary;

// this factors in the zoom level, if present, or defaults to a walkable span
- (MKCoordinateRegion)regionFromDictionary:(NSDictionary *)contentDictionary;


// should be handled by EWAMapManager
//- (CLLocationCoordinate2D)defaultMapCenter;
//- (MKCoordinateRegion)defaultMapRegion;

@end
