//
//  SHGMapViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 10/29/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// This is a simple wrapper for a full-screen, modal presentation of SHGMapView.
// It is intended for maps which display data, but don't navigate based on pin selection.
// Depending on the transitions decided upon, it might make sense
// to reintegrate these two classes into one.

#import <UIKit/UIKit.h>

#import "SHGMapView.h"

@interface SHGMapViewController : UIViewController <SHGMapViewDelegate>

@property (nonatomic) BOOL showCallouts;

// no callout accessories, because there is no push navigation from this VC
//@property (nonatomic) BOOL showCalloutAccessories;

// pass a nil title to omit the header
- (id)initWithTitle:(NSString *)title region:(MKCoordinateRegion)region footer:(NSString *)footer;

// returns default view if map is not initialized yet
- (MKCoordinateRegion)currentRegion;

// expects an array of SHGMapAnnotation objects
- (void)addAnnotations:(NSArray *)annotations;

@end
