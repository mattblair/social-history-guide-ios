//
//  SHGMapView.m
//  knowYourCity
//
//  Created by Matt Blair on 10/21/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGMapView.h"

@interface SHGMapView ()

@property (nonatomic) MKCoordinateRegion initialRegion;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *locationButton;

@property (strong, nonatomic) MKMapView *mapView;

// footer display -- more complex than a label?
@property (strong, nonatomic) UILabel *footerLabel;

@end

@implementation SHGMapView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title region:(MKCoordinateRegion)region footer:(NSString *)footer {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _showCalloutAccessories = YES;
        _showCallouts = YES;
        
        self.backgroundColor = [UIColor whiteColor]; // or some kind of transparency?
        
        CGFloat buttonSize = 44.0;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.closeButton setImage:[UIImage imageNamed:@"53-house"]
                          forState:UIControlStateNormal];
        
        [self.closeButton addTarget:self
                             action:@selector(closeMapView:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        self.closeButton.frame = CGRectMake(0.0, 64.0, buttonSize, buttonSize);
        
        [self addSubview:self.closeButton];
        
        
        CGFloat titleWidth = self.bounds.size.width - buttonSize*2.0;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonSize, 64.0,
                                                                    titleWidth, buttonSize)];
        // should be one line, preferably one word
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.titleLabel];
        
        self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.locationButton setImage:[UIImage imageNamed:@"193-location-arrow"]
                             forState:UIControlStateNormal];
        
        [self.locationButton addTarget:self
                                action:@selector(centerMapOnUser:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat locationX = self.bounds.size.width - buttonSize;
        self.locationButton.frame = CGRectMake(locationX, 64.0, buttonSize, buttonSize);
        
        [self addSubview:self.locationButton];
        
        // mapview should take up the whole screen, except maybe a footer at the bottom
        CGRect mapRect = CGRectMake(0.0, buttonSize+64.0, self.bounds.size.width, self.bounds.size.height - buttonSize);
        
        self.mapView = [[MKMapView alloc] initWithFrame:mapRect];
        
        self.mapView.delegate = self;
        
        // set region
        self.initialRegion = region;
        
        self.mapView.region = self.initialRegion;
        
        [self addSubview:self.mapView];
        
        // footer not handled yet
        
    }
    return self;
}

- (void)addAnnotations:(NSArray *)annotations {
    
    // store these annotations anywhere?
    
    [self.mapView addAnnotations:annotations];
    
    // reposition map automatically?
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
        
        if (ON_IPAD) {
            
            // pin drop looks terrible in a full screen map on iPad 3
            pinView.animatesDrop = NO;
        } else {
            
            pinView.animatesDrop = YES;
            
            // Add a detail disclosure button to the callout
            if (self.showCalloutAccessories) {
                UIButton* rightButton = [UIButton buttonWithType:
                                         UIButtonTypeDetailDisclosure];
                
                pinView.rightCalloutAccessoryView = rightButton;
            }
        }
        
        pinView.canShowCallout = self.showCallouts;
        pinView.pinColor = MKPinAnnotationColorGreen;
	}
    
	return pinView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    DLog(@"");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
    DLog(@"Will locate user");
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    // disable the user location button
    
    // show an alert?
}

#pragma mark - Responding to User Actions

- (void)closeMapView:(id)sender {
    
    [self.delegate mapView:self didFinishWithSelectedID:NSNotFound ofType:SHGSearchResultTypeStory];
}

- (void)centerMapOnUser:(id)sender {
    
    // if available, else return to initial region
    
    if (NO) {
        
        //
    } else {
        
        [self.mapView setRegion:self.initialRegion animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    // hide map
    
    // cast annotation to pull relevant data
    
    SHGMapAnnotation *tappedAnnotation = (SHGMapAnnotation *)view.annotation;
    
    DLog(@"Would handle tap on %@", [tappedAnnotation description]);
    
    // pin tap should call
    // - (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger *)itemID ofType:(SHGMapAnnotationType)pinType;
}

@end
