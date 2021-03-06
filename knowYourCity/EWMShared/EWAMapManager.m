//
//  EWAMapManager.m
//  knowYourCity
//
//  Created by Matt Blair on 10/30/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "EWAMapManager.h"


// ALL these defines would be read from JSON config file, too
#define RECENT_LOCATION_CUTOFF 15.0 // in seconds

#define LOCATION_ACCURACY_MINIMUM 1500.0 // too big?

// needs adjustment
#define DATASET_CENTER_LATITUDE 45.516249
#define DATASET_CENTER_LONGITUDE -122.678706
#define DATASET_RADIUS_MAX 3000.0

#define kSearchResultsLatitudeDeltaMultiplier 1.5 //1.15
#define kSearchResultsLongitudeDeltaMultiplier 1.3 //1.2

// originally 45.505796, -122.678586
#define MAP_LAUNCH_LATITUDE 45.516249
#define MAP_LAUNCH_LONGITUDE -122.678706

#define DEFAULT_LATITUDE_SPAN 0.042366
#define DEFAULT_LONGITUDE_SPAN 0.038389

@interface EWAMapManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation EWAMapManager

#pragma mark - Singleton & Init

+ (EWAMapManager *)sharedInstance {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleBackgrounding:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleBackgrounding:(NSNotification *)note {
    
    // Is this handled automatically by pausesLocationUpdatesAutomatically ?
    
    [self stopLocationUpdates];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopLocationUpdates {
    
    [[self locationManager] stopUpdatingLocation];
}

- (void)restartLocationUpdates {
    
    [[self locationManager] startUpdatingLocation];
}

- (void)startup {
    
    DLog(@"EWA Map Manager started...");
}

#pragma mark - Regions and Centroids

- (CLLocationCoordinate2D)launchCenter {
    
    return CLLocationCoordinate2DMake(MAP_LAUNCH_LATITUDE, MAP_LAUNCH_LONGITUDE);
}

- (MKCoordinateRegion)launchRegion {
    
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(DEFAULT_LATITUDE_SPAN, DEFAULT_LONGITUDE_SPAN);
    
    return MKCoordinateRegionMake([self launchCenter], defaultSpan);
}

// DEPRECATED?
- (BOOL)inLaunchRegion {
    
    DLog(@"Requested test of location in launch region");
    return NO;
}

- (MKCoordinateRegion)datasetRegion {
    
    MKCoordinateSpan defaultSpan = MKCoordinateSpanMake(DEFAULT_LATITUDE_SPAN, DEFAULT_LONGITUDE_SPAN);
    
    return MKCoordinateRegionMake([self launchCenter], defaultSpan);
}

- (BOOL)inDatasetRegion {
    
    return NO;
}



- (MKCoordinateRegion)regionForUserLocationAndDataRegion:(MKCoordinateRegion)dataRegion {
    
    if ([self hasValidLocation] ) {
        
        // get centroid of dataRegion
        
        CLLocationCoordinate2D dataCenter = dataRegion.center;
        CLLocationCoordinate2D locationCenter = self.locationManager.location.coordinate;
        
        CLLocationDegrees minLatitude = MIN(dataCenter.latitude, locationCenter.latitude);
        CLLocationDegrees maxLatitude = MAX(dataCenter.latitude, locationCenter.latitude);
        
        CLLocationDegrees minLongitude = MIN(dataCenter.longitude, locationCenter.longitude);
        CLLocationDegrees maxLongitude = MAX(dataCenter.longitude, locationCenter.longitude);
        
        // build a region around that inclusive of both
        
        MKCoordinateRegion inclusiveRegion;
        
        // calculate centroid of user location and data centroid
        inclusiveRegion.center.latitude = (maxLatitude - minLatitude)/2 + minLatitude;
        inclusiveRegion.center.longitude = (maxLongitude - minLongitude)/2 + minLongitude;
        
        inclusiveRegion.span.latitudeDelta = (maxLatitude - minLatitude)*kSearchResultsLatitudeDeltaMultiplier;
        inclusiveRegion.span.longitudeDelta = (maxLongitude - minLongitude)*kSearchResultsLongitudeDeltaMultiplier;
        
        return inclusiveRegion;
        
    } else {
        
        return dataRegion;
    }
}

- (MKCoordinateRegion)currentOrLaunchRegion {
    
    return [self regionForUserLocationAndDataRegion:[self launchRegion]];
}

- (MKCoordinateRegion)walkableRegionForCurrentLocation {
    
    if ([self hasValidLocation] ) {
        
        return [self walkableRegionAroundCoordinate:self.locationManager.location.coordinate];
    } else {
        
        return [self walkableRegionAroundCoordinate:[self launchCenter]];
    }
}

- (MKCoordinateRegion)walkableCurrentRegionOrLaunchRegion {
    
    if ([self hasValidLocation] ) {
        
        return [self walkableRegionAroundCoordinate:self.locationManager.location.coordinate];
    } else {
        
        return [self launchRegion];
    }
}

- (MKCoordinateRegion)walkableRegionAroundCoordinate:(CLLocationCoordinate2D)coordinate {
    
    CLLocationDistance latitudeSpan = WALKABLE_LATITUDE_SPAN;
    CLLocationDistance longitudeSpan = WALKABLE_LONGITUDE_SPAN;
    
    return MKCoordinateRegionMakeWithDistance(coordinate,
                                              latitudeSpan, longitudeSpan);
}

#pragma mark - Coordinate Validation

- (BOOL)hasValidLocation {
    
    // early return if no permissions
    if (![self hasLocationPermissions]) {
        return NO;
    }
    
    BOOL hasLocation = NO; // default, if location disabled
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        BOOL recentLocation = [self recentEnoughLocation:self.locationManager.location];
        BOOL accurateLocation = [self accurateEnoughLocation:self.locationManager.location];
        BOOL withinData = [self datasetContainsLocation:self.locationManager.location];
        
        hasLocation = recentLocation && accurateLocation && withinData;
    }
    
    return hasLocation;
}

- (BOOL)recentEnoughLocation:(CLLocation *)location {
    
    if (location) {
        NSDate *locationDate = location.timestamp;
        NSTimeInterval timeDiff = fabs([locationDate timeIntervalSinceNow]);
        
        return (timeDiff >= 0.0) && (timeDiff < RECENT_LOCATION_CUTOFF);
    } else {
        return NO;
    }
}

- (BOOL)accurateEnoughLocation:(CLLocation *)location {
    
    if (location) {
        CLLocationAccuracy accuracyRadius = location.horizontalAccuracy;
        
        // negative values indicate the location is invalid
        return (accuracyRadius >= 0.0) && (accuracyRadius < LOCATION_ACCURACY_MINIMUM);
    } else {
        
        return NO;
    }
}

- (BOOL)datasetContainsLocation:(CLLocation *)location {
    
    if (location) {
        CLLocation *datasetCentroid = [[CLLocation alloc] initWithLatitude:DATASET_CENTER_LATITUDE
                                                                 longitude:DATASET_CENTER_LONGITUDE];
        
        CLLocationDistance radius = [location distanceFromLocation:datasetCentroid];
        
        return radius > 0.0 && radius < DATASET_RADIUS_MAX;
    } else {
        
        return NO;
    }
}


#pragma mark - CLLocationManagerDelegate methods

- (CLLocationManager *)locationManager {
	
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        // or kCLLocationAccuracyNearestTenMeters if you need accuracy more than battery life
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setDelegate:self];
	}
	
	return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // locations is an array of CLLocation objects in order received
    DLog(@"Location is: %@", [locations lastObject]);

    // send notifications only if needed, or throttle this using distanceFilter
//    if ([self recentEnoughLocation:[locations lastObject]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationAvailableNotification
//                                                            object:nil];
//    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	 DLog(@"Location Failure.");
	 DLog(@"Error: %@", [error localizedDescription]);
	 DLog(@"Error code %ld in domain: %@", (long)[error code], [error domain]);
	
    [[self locationManager] stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationFailureNotification
                                                        object:nil];
    
    // this check originated in handling behavior in 4.1. Presumably that's all behind us?
	if (([error code] == 1) && ([[error domain] isEqualToString:@"kCLErrorDomain"])) {
		
		DLog(@"4.1 Error Check");
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    DLog(@"CL Authorization changed: %d", status);
    
    [self updateLocationHandlingWithAuthorizationStatus:status];
}


#pragma mark - Managing Location Permissions

- (BOOL)hasLocationPermissions {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    return status == kCLAuthorizationStatusAuthorizedWhenInUse || status ==  kCLAuthorizationStatusAuthorizedAlways;
}

- (void)verifyOrStartLocationUpdates {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self updateLocationHandlingWithAuthorizationStatus:status];
    }
}

- (void)updateLocationHandlingWithAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSString *notificationName = nil;
    if ([self hasLocationPermissions] && [CLLocationManager locationServicesEnabled]) {
        DLog(@"Starting location updates");
        [self.locationManager startUpdatingLocation];
        notificationName = kLocationPermissionGrantedNotification;
        
    } else {
        DLog(@"Will not use location");
        [self.locationManager stopUpdatingLocation];
        notificationName = kLocationPermissionRefusedNotification;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:nil];
}

- (void)stopTrackingLocation {
    DLog(@"Stopping location updates");
    [self.locationManager stopUpdatingLocation];
}

@end
