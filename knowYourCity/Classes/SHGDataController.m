//
//  SHGDataController.m
//  knowYourCity
//
//  Created by Matt Blair on 10/14/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGDataController.h"

#import <FMDB/FMDatabase.h>

#import "SHGMapAnnotation.h"
#import "EWAMapManager.h"

@interface SHGDataController ()

@property (strong, nonatomic) FMDatabase *shgDatabase;

@end

@implementation SHGDataController

#pragma mark - Singleton and Init Code

+ (SHGDataController *)sharedInstance {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"shg-web"
                                                           ofType:@"sqlite"];
        
        self.shgDatabase = [FMDatabase databaseWithPath:dbPath];
        
        if (![self.shgDatabase open]) {
            
            DLog(@"Database failed");
        }
    }
    return self;
}

- (void)dealloc {
    
    if (self.shgDatabase) {
        
        if ([self.shgDatabase hasOpenResultSets]) {
            [self.shgDatabase closeOpenResultSets];
        }
        
        [self.shgDatabase close];
    }
}


#pragma mark - Testing Utilities

- (BOOL)appStoreBuild {
    
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:kAppStoreBundleID];
}


#pragma mark - Themes

// performance might be better if all themes were lazy-loaded once?
- (NSString *)nameForThemeID:(NSUInteger)themeID {
    
    NSString *themeName = nil;
    
    NSString *selectString = [NSString stringWithFormat:@"select title from themes where id = %d;", themeID];
    
    FMResultSet *results = [self.shgDatabase executeQuery:selectString];
    
    while ([results next]) {
        
        themeName = [results stringForColumn:@"title"];
    }
    
    return themeName;
}

- (NSArray *)publishedThemes {
    
    if (!_publishedThemes) {
        
        NSMutableArray *themes = [[NSMutableArray alloc] initWithCapacity:15];
        
        FMResultSet *s = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM themes where workflow_state_id = %d;", PUBLISHED_WORKFLOW_STATE];
        
        while ([s next]) {
            
            [themes addObject:[s resultDictionary]];
            //DLog(@"Theme title: %@", [s stringForColumn:kContentTitleKey]);
        }
        
        _publishedThemes = [NSArray arrayWithArray:themes];
    }
    
    return _publishedThemes;
}

#pragma mark - Stories

- (NSArray *)storiesForThemeID:(NSUInteger)themeID {
    
    NSMutableArray *stories = [[NSMutableArray alloc] initWithCapacity:10];
    
    FMResultSet *resultSet = [self.shgDatabase executeQueryWithFormat:
                              @"SELECT * FROM stories where theme_id = %d and workflow_state_id = %d order by display_order;",
                              themeID,
                              PUBLISHED_WORKFLOW_STATE];

    while ([resultSet next]) {
        
        [stories addObject:[resultSet resultDictionary]];
    }
    
    return [NSArray arrayWithArray:stories];
}

- (NSArray *)storyMapAnnotationsForThemeID:(NSUInteger)themeID {
    
    NSArray *stories = [self storiesForThemeID:themeID];
    
    if ([stories count] > 0) {
    
        NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[stories count]];
        
        for (NSDictionary *aStory in stories) {
            
            // could use projectBoundindBoxContainsCoordinate class method to
            // avoid object creation,
            // but for a small dataset, that probably isn't much of a savings.
            
            SHGMapAnnotation *storyAnnotation = [[SHGMapAnnotation alloc] initWithDictionary:aStory];
            
            if (storyAnnotation.validCoordinate) {
                [annotations addObject:storyAnnotation];
            }
        }
        
        return [annotations count] > 0 ? [NSArray arrayWithArray:annotations] : nil;
        
    } else { // no stories
        
        return nil;
    }
}

// adapt to handle flashbacks in the future? Or have a distinct method for that?
// more efficient:
// altered version of storiesForThemeID that includes location_valid in where clause
// but are those values always reliable? need further testing.
- (NSUInteger)countOfValidStoryAnnotationsForThemeID:(NSUInteger)themeID {
    
    NSUInteger storyCount = 0;
    
    NSArray *storyArray = [self storyMapAnnotationsForThemeID:themeID];
    
    for (SHGMapAnnotation *annotation in storyArray) {
        if (annotation.validCoordinate) {
            storyCount++;
        }
    }
    
    return storyCount;
}

- (NSArray *)mapAnnotationsOfType:(SHGSearchResultType)resultType inRegion:(MKCoordinateRegion)region maxCount:(NSUInteger)maxCount {
    
    NSArray *results = nil;
    
    // calculate bounding box: -- add a buffer to this?
    CLLocationDegrees southernEdge = region.center.latitude - region.span.latitudeDelta/2.0;
    CLLocationDegrees northernEdge = region.center.latitude + region.span.latitudeDelta/2.0;
    CLLocationDegrees westernEdge = region.center.longitude - region.span.longitudeDelta/2.0;
    CLLocationDegrees easternEdge = region.center.longitude + region.span.longitudeDelta/2.0;
    
    NSUInteger rowLimit = MAX(10, maxCount); // at least 10, but the argument can override?
    
    // set maxCount in query, or in annotation-creating loop?
    NSString *queryTemplate = @"select id, title, subtitle, theme_id, latitude, longitude "
                               "from %@ where "
                               "latitude>%.6lf AND latitude<%.6lf AND longitude>%.6lf AND longitude<%.6lf "
                               "and workflow_state_id = %d "
//                               "and location_valid = \"t" " // test this. not sure if database is consistently flagged yet.
                               "order by latitude desc, longitude " // should be from top left
                               "LIMIT %d;";
    
    NSString *queryStatement = [NSString stringWithFormat:queryTemplate,
                                @"stories", //  in future versions, this will need to happen within each case
                                southernEdge, northernEdge, westernEdge, easternEdge,
                                PUBLISHED_WORKFLOW_STATE,
                                rowLimit];
    
    DLog(@"Query statement: %@", queryStatement);
    
    switch (resultType) {
        case SHGSearchResultTypeStory: {
            
            NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:maxCount];
            
            FMResultSet *resultSet = [self.shgDatabase executeQuery:queryStatement];
            
            DLog(@"Query was: %@", resultSet.query);
            
            while ([resultSet next]) {
                
                // add annotation, not the dictionary, and only if it inits successfully
                SHGMapAnnotation *anAnnotation = [[SHGMapAnnotation alloc] initWithDictionary:[resultSet resultDictionary]];
                
                if (anAnnotation) {
                    
                    NSNumber *themeID = [[resultSet resultDictionary] objectForKey:kContentThemeIDKey];
                    
                    // themes are 1-indexed
                    if ([themeID integerValue] > 0) {
                        anAnnotation.subtitle = [self nameForThemeID:[themeID unsignedIntegerValue]];
                    }
                    
                    [annotations addObject:anAnnotation];
                } else {
                    DLog(@"Unable to create an annotation with dictionary: %@", [resultSet resultDictionary]);
                }
                
                if ([annotations count] >= maxCount) {
                    break;
                }
            }
            
            results = [NSArray arrayWithArray:annotations];
            break;
        }
            
        case SHGSearchResultTypeFlashback: {
            
            DLog(@"Flashback map results deferred until 1.1");
            break;
        }
            
        case SHGSearchResultTypeStoryFlashback: {
            
            // run separate searches for story and flash back, combine the arrays up to maxCount
            
            DLog(@"Combined search results deferred until 1.1");
            break;
        }
            
            
            
        default:
            DLog(@"Unhandled search request of type %d", resultType);
            break;
    }
    
    return results;
}

- (NSDictionary *)dictionaryForStoryID:(NSUInteger)storyID {
    
    NSDictionary *guestDictionary = nil;
    
    FMResultSet *resultSet = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM stories where id = %d;", storyID];
    
    while ([resultSet next]) {
        
        guestDictionary = [resultSet resultDictionary];
    }
    
    return guestDictionary;
}

#pragma mark - Guests

- (NSDictionary *)dictionaryForGuestID:(NSUInteger)guestID {
    
    NSDictionary *guestDictionary = nil;
    
    FMResultSet *resultSet = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM guests where id = %d;", guestID];
    
    while ([resultSet next]) {
        
        guestDictionary = [resultSet resultDictionary];
    }
    
    return guestDictionary;
}


#pragma mark - URL Helpers

- (NSURL *)urlForPhotoNamed:(NSString *)photoName {
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@.jpg", kPhotosURL, photoName];
    
    return [NSURL URLWithString:urlString];
}

// always return the text-less image, because the offline warning is too small to read
- (UIImage *)thumbnailPlaceholder {
    
    return [UIImage imageNamed:kPhotoPlaceholderImage];
}

- (UIImage *)photoPlaceholder {
    
    if ([SHG_APP_DELEGATE currentlyOnline]) {
        
        return [UIImage imageNamed:kPhotoPlaceholderImage];
    } else {
        
        return [UIImage imageNamed:kOfflinePhotoPlaceholderImage];
    }
}

- (NSURL *)urlForAudiofileNamed:(NSString *)audiofile {
    
    // switch to .caf once uploaded...
    NSString *urlString =[NSString stringWithFormat:@"%@%@.mp3", kAudioURL, audiofile];
    
    return [NSURL URLWithString:urlString];
}

#pragma mark - Map Helper Methods

- (CLLocationCoordinate2D)coordinateFromDictionary:(NSDictionary *)contentDictionary {
    
    // use SHGMapAnnotation's validation?
    
    NSNumber *latitude = [contentDictionary objectForKey:kContentLatitudeKey];
    NSNumber *longitude = [contentDictionary objectForKey:kContentLongitudeKey];

    return CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
}

- (MKCoordinateRegion)regionFromDictionary:(NSDictionary *)contentDictionary {
    
    // in meters
    CLLocationDistance latitudeSpan;
    CLLocationDistance longitudeSpan;
    
    NSNumber *zoom = [contentDictionary objectForKey:kContentZoomLevelKey];
    
    NSUInteger zoomFactor = zoom ? [zoom unsignedIntegerValue] : NSNotFound;
    
    // valued used for themes in 1.0 are: 8 (native stories) and 12-16 for more local themes
    // Are these values standardized? Are they hard-coded values or is it a relative scale?
    // according to this: https://developers.google.com/maps/documentation/staticmaps/#Zoomlevels
    // the values range from 0 (whole world) to ~21 (individual buildings), and
    // each increment doubles the zoom
    switch (zoomFactor) {
        case 8: {
            
            latitudeSpan = 76800.0;
            longitudeSpan = 102400.0;
            break;
        }
            
        case 12: {
            
            latitudeSpan = 4800.0;
            longitudeSpan = 6400.0;
            break;
        }
            
        case 13: {
            
            latitudeSpan = 2400.0;
            longitudeSpan = 3200.0;
            break;
        }
            
        case 14: {
            
            latitudeSpan = 1200.0;
            longitudeSpan = 1600.0;
            break;
        }
            
        case 15: {
            
            latitudeSpan = 600.0;
            longitudeSpan = 800.0;
            break;
        }
            
        case 16: {
            
            latitudeSpan = 300.0;
            longitudeSpan = 400.0;
            break;
        }
            
        default: { // will handle NSNotFound i.e. undefined
            
            DLog(@"Zoom level not defined in dictionary.");
            
            // default to a walkable span
            latitudeSpan = WALKABLE_LATITUDE_SPAN;
            longitudeSpan = WALKABLE_LONGITUDE_SPAN;
            break;
        }
    }
		
    return MKCoordinateRegionMakeWithDistance([self coordinateFromDictionary:contentDictionary],
                                              latitudeSpan, longitudeSpan);
}

@end
