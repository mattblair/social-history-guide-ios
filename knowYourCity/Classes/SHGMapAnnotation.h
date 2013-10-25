//
//  SHGMapAnnotation.h
//  knowYourCity
//
//  Created by Matt Blair on 10/15/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, SHGMapAnnotationType) {
    SHGMapAnnotationTypeTheme = 0,
    SHGMapAnnotationTypeStory,
    SHGMapAnnotationTypeGuest,
    SHGMapAnnotationTypeFlashback
};

@interface SHGMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSNumber *contentID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) BOOL validCoordinate;

@property (nonatomic) SHGMapAnnotationType annotationType;

// project bounding box testing
+ (BOOL)validLatitude:(CLLocationDegrees)latitudeValue;
+ (BOOL)validLongitude:(CLLocationDegrees)longitudeValue;
+ (BOOL)projectBoundindBoxContainsCoordinate:(CLLocationCoordinate2D)coordinate;

- (id)initWithDictionary:(NSDictionary *)contentDictionary;

- (NSString *)description;

// possibly deprecated if photos won't be shown in annotations
- (BOOL)hasPhoto;

// (Copied from TidbitMapAnnotation, but might not be needed...)
// accepts a dictionary from JSON with geometry key that has a point in it
- (BOOL)setCoordinateFromGeoJSONFragment:(NSDictionary *)geoJSON;

@end
