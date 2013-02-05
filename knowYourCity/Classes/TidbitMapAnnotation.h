//
//  TidbitMapAnnotation.h
//  knowYourCity
//
//  Created by Matt Blair on 2/4/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TidbitMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (BOOL)hasPhoto;

// accepts a dictionary from JSON with geometry key that has a point in it
- (BOOL)setCoordinateFromGeoJSONFragment:(NSDictionary *)geoJSON;

@end
