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

// temporary -- will be 6
#define PUBLISHED_WORKFLOW_STATE 2

// Cross-table keys

#define kContentIDKey @"id"
#define kContentTitleKey @"title"
#define kContentSubtitleKey @"subtitle"
#define kContentSlugKey @"slug"

#define kContentLatitudeKey @"latitude"
#define kContentLongitudeKey @"longitude"
#define kContentZoomLevelKey @"zoom_level"

// Theme keys
#define kThemeIDKey @"id"
#define kThemeSummaryKey @"summary"
#define kThemeImageKey @"image_name"

// also: latitude, longitude, zoom_level -- available through helper method?

// Story keys
#define kStoryIDKey @"id"
#define kStorySummaryKey @"summary"
#define kStoryImageKey @"image_name"

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


// Guests


@end
