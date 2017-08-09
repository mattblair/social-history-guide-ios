//
//  MapViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 2/4/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "MapViewController.h"
#import "TidbitMapAnnotation.h"

#define kDefaultRegionLatitude 45.520764 //45.518978
#define kDefaultRegionLongitude -122.674987 //-122.676001

#define kDefaultRegionLatitudeDelta 0.020743 // 0.013832
#define kDefaultRegionLongitudeDelta 0.026834// 0.013733

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
	
    // map
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];

    
    // add button to flip back
    
    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [flipButton setImage:[UIImage imageNamed:@"53-house"]
                forState:UIControlStateNormal];
    [flipButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    
    // upper right
    //flipButton.frame = CGRectMake(276.0, 20.0, 44.0, 44.0);
    
    // lower right -- lower left conflicts with legal notice
    CGFloat buttonSize = 44.0;
    CGFloat flipX = self.view.bounds.size.width - buttonSize;
    CGFloat flipY = self.view.bounds.size.height - buttonSize;
    flipButton.frame = CGRectMake(flipX, flipY, buttonSize, buttonSize);
    
    [self.view addSubview:flipButton];
    
    // zoom into Portland
    [self setInitialMapRegion];
    
    NSArray *annotations = [self makeAnnotationArray:self.dataArray];
    
    [self.mapView addAnnotations:annotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goHome {
    
    // no selections to handle yet...
    
    [self.delegate mapViewController:self didFinishWithSelection:NSNotFound];
}

#pragma mark - Map Utility

- (void)setInitialMapRegion { // because CL might not have a valid location yet
	
	MKCoordinateRegion initialRegion;
	
	initialRegion.center.latitude = kDefaultRegionLatitude;
	initialRegion.center.longitude = kDefaultRegionLongitude;
	
	initialRegion.span.latitudeDelta = kDefaultRegionLatitudeDelta;
	initialRegion.span.longitudeDelta = kDefaultRegionLongitudeDelta;
	
    [self.mapView setRegion:initialRegion animated:NO];
    
}

-(NSArray *)makeAnnotationArray:(NSArray *)rawData {
    
    NSMutableArray *annotationList = [NSMutableArray arrayWithCapacity:[rawData count]];
	
	if ([rawData count] > 0) {
		
		TidbitMapAnnotation *ta = nil;
		
		for (NSDictionary *aTidbit in rawData) {
			
			// create an annotation
			
			ta = [[TidbitMapAnnotation alloc] init];
			
			[ta setTitle:[aTidbit objectForKey:@"title"]];
			// add tips for finding as subtitle in future?
			[ta setSubtitle:[aTidbit objectForKey:@"theme"]];
			
            /*
            NSArray *coord = [[aTidbit objectForKey:@"geometry"] objectForKey:@"coordinates"];
            
			[ta setLatitude:coord[1]];
			[ta setLongitude:coord[0]];
			*/
            
            [ta setCoordinateFromGeoJSONFragment:aTidbit];
            
			[annotationList addObject:ta];
		}
	}
	
	else {
		
		// This should never appear, because the user is always notified by UIAlertView if nothing is found.
		// If it does appear, there is a problem.
		NSLog(@"Nothing to add to the array.");
	}
	
	return annotationList;
}


#pragma mark - MKMapView Delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Try to dequeue an existing pin view first.
	MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView
														  dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
	
	if (!pinView)
	{
		// If an existing pin view was not available, create one.
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:@"CustomPinAnnotationView"];
		
        // commenting as a test fix for the terrible performance on iPad 3
        //pinView.animatesDrop = YES;
        
        if (ON_IPAD) {
            
            pinView.animatesDrop = NO;
            pinView.canShowCallout = NO;
        } else {
            
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // Add a detail disclosure button to the callout
            //UIButton* rightButton = [UIButton buttonWithType:
            //                         UIButtonTypeDetailDisclosure];
            
            //pinView.rightCalloutAccessoryView = rightButton;
        }
        
        pinView.pinTintColor = [MKPinAnnotationView greenPinColor];
	}
    
	return pinView;
}

@end
