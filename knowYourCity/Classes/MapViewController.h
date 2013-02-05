//
//  MapViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 2/4/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// This View controller will change A LOT!

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) id <MapViewControllerDelegate> delegate;

// expects an array of dictionaries, via GeoJSON
@property (strong, nonatomic) NSArray *dataArray;

@end

@protocol MapViewControllerDelegate <NSObject>

- (void)mapViewController:(MapViewController *)mapVC didFinishWithSelection:(NSUInteger *)itemIndex;

@end