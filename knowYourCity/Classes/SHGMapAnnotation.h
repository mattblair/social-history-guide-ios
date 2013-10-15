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
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) SHGMapAnnotationType annotationType;

// could be either story or flashback/tidbit
- (id)initWithDictionary:(NSDictionary *)contentDictionary;

// possibly deprecated if photos won't be shown in annotations
- (BOOL)hasPhoto;

// (Copied from TidbitMapAnnotation, but might not be needed...)
// accepts a dictionary from JSON with geometry key that has a point in it
- (BOOL)setCoordinateFromGeoJSONFragment:(NSDictionary *)geoJSON;

@end
