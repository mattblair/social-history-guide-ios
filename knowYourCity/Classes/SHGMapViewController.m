//
//  SHGMapViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 10/29/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGMapViewController.h"

@interface SHGMapViewController ()

@property (nonatomic) MKCoordinateRegion defaultRegion;
@property (strong, nonatomic) NSString *footer;

@property (strong, nonatomic) SHGMapView *mapView;

@end

@implementation SHGMapViewController

- (id)initWithTitle:(NSString *)title region:(MKCoordinateRegion)region footer:(NSString *)footer {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        self.title = title;
        self.defaultRegion = region;
        self.footer = footer;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.mapView = [[SHGMapView alloc] initWithFrame:self.view.bounds
                                               title:self.title
                                              region:self.defaultRegion
                                              footer:self.footer];
    
    self.mapView.delegate = self;
    self.mapView.showCalloutAccessories = NO;
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map Management (Proxy methods for private map view)

- (void)setShowCallouts:(BOOL)showCallouts {
    
    _showCallouts = showCallouts;
    
    [self.mapView setShowCallouts:_showCallouts];
}

// returns default view if map is not initialized yet
- (MKCoordinateRegion)currentRegion {
    
    return [self.mapView currentRegion];
}

// expects an array of SHGMapAnnotation objects
- (void)addAnnotations:(NSArray *)annotations {
    
    [self.mapView addAnnotations:annotations];
}

#pragma mark - SHGMapViewDelegate method

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType {
    
    // at least initially, this VC does not support acting on pin selection
    // see header for details
    
    if (itemID == NSNotFound) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES
                                                          completion:NULL];
        
    } else {
     
        DLog(@"Tapped item: %d", itemID);
    }
}

@end
