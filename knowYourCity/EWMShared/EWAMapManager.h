//
//  EWAMapManager.h
//  knowYourCity
//
//  Created by Matt Blair on 10/30/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// this pulls the necessary code from poetryboxes' EWMapRegionManager
// This should be turned into a CocoaPod that handles all the boilerplate,
// then included that way, instead of as a file here

// Dependencies:
//   * MapKit and CoreLocation frameworks
//   * JSONKit
//   * DLog macro defined
//   * DEFINE_SHARED_INSTANCE_USING_BLOCK macro defined

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define EWA_MM [EWAMapManager sharedInstance]

// these configurations would be read from a json file:

#define WALKABLE_LATITUDE_SPAN 375.0
#define WALKABLE_LONGITUDE_SPAN 500.0

@interface EWAMapManager : NSObject <CLLocationManagerDelegate>

+ (EWAMapManager *)sharedInstance;

- (void)startup;

// are these properly handled by pausesLocationUpdatesAutomatically ?
- (void)stopLocationUpdates;
- (void)restartLocationUpdates;

- (MKCoordinateRegion)launchRegion;
- (BOOL)inLaunchRegion;

// returns a region that encompasses all data provided in this app
- (MKCoordinateRegion)datasetRegion;
- (BOOL)inDatasetRegion;

- (BOOL)hasValidLocation;


- (MKCoordinateRegion)regionForUserLocationAndDataRegion:(MKCoordinateRegion)dataRegion;

// based on location if available

// returns a region which combines current location and launch region, or just launch region
- (MKCoordinateRegion)currentOrLaunchRegion;

// if location is not available, the walkable region is based on default center
- (MKCoordinateRegion)walkableRegionForCurrentLocation;

// if location is not available, returns default region -- which may not be walkable
- (MKCoordinateRegion)walkableCurrentRegionOrLaunchRegion;

- (MKCoordinateRegion)walkableRegionAroundCoordinate:(CLLocationCoordinate2D)coordinate;

@end
