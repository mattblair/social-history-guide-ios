//
//  TidbitMapAnnotation.m
//  knowYourCity
//
//  Created by Matt Blair on 2/4/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "TidbitMapAnnotation.h"

@implementation TidbitMapAnnotation

@synthesize coordinate=_coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        
        _coordinate = coord;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    
    // this assumes values have been set after init, and have been validated...
    // use the JSON setter instead? or at least validate the values.
    //_coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    return _coordinate;
}

- (BOOL)hasPhoto {
    
    //return self.photoURL && [self.photoURL length] > 0;
    return NO;
}

- (BOOL)setCoordinateFromGeoJSONFragment:(NSDictionary *)geoJSON {
    
    NSArray *coordArray = [[geoJSON objectForKey:@"geometry"] objectForKey:@"coordinates"];
    
    BOOL coordinateValid = YES;
    
    CLLocationDegrees latitudeValue = [coordArray[1] doubleValue];
    CLLocationDegrees longitudeValue = [coordArray[0] doubleValue];
    
    if (latitudeValue > 90.0 || latitudeValue < -90.0 ) {
        coordinateValid = NO;
    }
    
    if (longitudeValue > 180.0 || latitudeValue < -180.0 ) {
        coordinateValid = NO;
    }
    
    if (coordinateValid) {
        _coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue);
    } else {
        
        // defaulting to Portlandish
        _coordinate = CLLocationCoordinate2DMake(45.5, -122.6);
    }
    
    return coordinateValid;
}

@end
