//
//  SHGMapView.h
//  knowYourCity
//
//  Created by Matt Blair on 10/21/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SHGMapAnnotation.h"

// meant to be presnted as full-screen, and NOT in a scrollview

@protocol SHGMapViewDelegate;

@interface SHGMapView : UIView <MKMapViewDelegate>

@property (weak, nonatomic) id <SHGMapViewDelegate> delegate;

@property (nonatomic) BOOL showCallouts;
@property (nonatomic) BOOL showCalloutAccessories;

// pass a nil title to omit the header
- (id)initWithFrame:(CGRect)frame title:(NSString *)title region:(MKCoordinateRegion)region footer:(NSString *)footer;

// expose button image properties?

// returns default view if map is not initialized yet
- (MKCoordinateRegion)currentRegion;

// expects an array of SHGMapAnnotation objects
- (void)addAnnotations:(NSArray *)annotations;

@end

@protocol SHGMapViewDelegate <NSObject>

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType;

@end