//
//  SHGMapAnnotation.m
//  knowYourCity
//
//  Created by Matt Blair on 10/15/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGMapAnnotation.h"

// Validity tests whether the coordinate is in a project-specific bounding box
// to test the world, use the commented values

#define BBOX_LATITUDE_MAX 90.0      // 90.0
#define BBOX_LATITUDE_MIN -90.0     // -90.0

#define BBOX_LONGITUDE_MAX 180.0    // 180.0
#define BBOX_LONGITUDE_MIN -180.0   // -180.0


// project-specific placeholder values used if data is out of range
#define LATITUDE_ERROR_VALUE 45.5
#define LONGITUDE_ERROR_VALUE -122.6

@interface SHGMapAnnotation ()

// deprecated if you don't use the GeoJSON method
@property (nonatomic) CLLocationCoordinate2D coordinate;

// keep a copy of the initial dictionary?

@property (strong, nonatomic) NSNumber *contentID;

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@property (nonatomic) BOOL validCoordinate;

@end


@implementation SHGMapAnnotation

- (id)initWithDictionary:(NSDictionary *)contentDictionary {
    
    self = [super init];
    if (self) {
        
        // agnostic as to whether it's a theme, story or flashback item
        _contentID = [contentDictionary objectForKey:kContentIDKey];
        
        // read values from dictionary
        _title = [contentDictionary objectForKey:kContentTitleKey];
        _subtitle = [contentDictionary objectForKey:kContentSubtitleKey];
        
        // validate the geo values
        _latitude = [contentDictionary objectForKey:kContentLatitudeKey];
        _longitude = [contentDictionary objectForKey:kContentLongitudeKey];
        
        _validCoordinate = [self validLatitude:[_latitude doubleValue]] &&
                           [self validLongitude:[_longitude doubleValue]];
        
        // override after init for special cases
        _annotationType = SHGMapAnnotationTypeStory;
    }
    return self;
}

#pragma mark - MKAnnotation protocol

- (CLLocationCoordinate2D)coordinate {
    
    // this assumes values have been set after init, and have been validated...
    
    // don't really need an ivar, as long as validation has already happened.
    //_coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

#pragma mark - Styling and Display Utilities

// might be deprecated
- (BOOL)hasPhoto {
    
    //return self.photoURL && [self.photoURL length] > 0;
    return NO;
}

#pragma mark - GeoJSON Utilities


- (BOOL)validLatitude:(CLLocationDegrees)latitudeValue {
    
    return (latitudeValue <= BBOX_LATITUDE_MAX || latitudeValue >= BBOX_LATITUDE_MIN) ? YES : NO;
}

- (BOOL)validLongitude:(CLLocationDegrees)longitudeValue {
    
    return (longitudeValue <= BBOX_LONGITUDE_MAX || longitudeValue >= BBOX_LONGITUDE_MIN ) ? YES : NO;
}

- (BOOL)setCoordinateFromGeoJSONFragment:(NSDictionary *)geoJSON {
    
    NSArray *coordArray = [[geoJSON objectForKey:@"geometry"] objectForKey:@"coordinates"];
    
    BOOL coordinateValid = YES;
    
    CLLocationDegrees latitudeValue = [coordArray[1] doubleValue];
    CLLocationDegrees longitudeValue = [coordArray[0] doubleValue];
    
    coordinateValid = [self validLatitude:latitudeValue];
    
    coordinateValid = [self validLongitude:longitudeValue];
    
    // if it passed both tests
    if (coordinateValid) {
        _coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue);
    } else {
        
        // defaulting to Portlandish
        _coordinate = CLLocationCoordinate2DMake(LATITUDE_ERROR_VALUE, LONGITUDE_ERROR_VALUE);
    }
    
    return coordinateValid;
}

@end
