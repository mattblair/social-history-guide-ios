//
//  HomeViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHGMapView.h"

// was MapViewControllerDelegate too
@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SHGMapViewDelegate>

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType;

@end

