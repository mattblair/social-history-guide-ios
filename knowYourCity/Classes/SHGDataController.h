//
//  SHGDataController.h
//  knowYourCity
//
//  Created by Matt Blair on 10/14/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// temporary -- will be 6
#define PUBLISHED_WORKFLOW_STATE 2

// Theme keys
#define kThemeIDKey @"id"
#define kThemeTitleKey @"title"
#define kThemeSubtitleKey @"subtitle"
#define kThemeSummaryKey @"summary"
#define kThemeImageKey @"image_name"
#define kThemeSlugKey @"slug"

// also: latitude, longitude, zoom_level -- available through helper method?

// Story keys
#define kStoryIDKey @"id"
#define kStoryTitleKey @"title"
#define kStorySubtitleKey @"subtitle"
#define kStorySummaryKey @"summary"
#define kStoryImageKey @"image_name"
#define kStorySlugKey @"slug"

// Guest keys



@interface SHGDataController : NSObject

// returns dictionaries
@property (strong, nonatomic) NSArray *publishedThemes;

+ (SHGDataController *)sharedInstance;


// Themes

// Stories

- (NSArray *)storiesForThemeID:(NSUInteger)themeID;


// Guests


@end
