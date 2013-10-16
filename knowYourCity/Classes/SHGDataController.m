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

#pragma mark - Themes

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
    
    FMResultSet *resultSet = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM stories where theme_id = %d and workflow_state_id = %d;", themeID, PUBLISHED_WORKFLOW_STATE];

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

#pragma mark - Guests


#pragma mark - Helper Methods

- (CLLocationCoordinate2D)coordinateFromDictionary:(NSDictionary *)contentDictionary {
    
    // use SHGMapAnnotation's validation?
    
    NSNumber *latitude = [contentDictionary objectForKey:kContentLatitudeKey];
    NSNumber *longitude = [contentDictionary objectForKey:kContentLongitudeKey];

    return CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
}

- (MKCoordinateRegion)regionFromDictionary:(NSDictionary *)contentDictionary {
    
    // in meters
    CLLocationDistance walkableLatitudeSpan = 500.0;
    CLLocationDistance walkableLongitudeSpan = 500.0;
    
    NSNumber *zoom = [contentDictionary objectForKey:kContentZoomLevelKey];
    
    if (zoom) {
        // use zoom level as multiplier instead of hard-coded values
        DLog(@"Would adjust for zoom level %d", [zoom integerValue]);
    }
		
    return MKCoordinateRegionMakeWithDistance([self coordinateFromDictionary:contentDictionary],
                                                  walkableLatitudeSpan, walkableLongitudeSpan);
        
}

@end
