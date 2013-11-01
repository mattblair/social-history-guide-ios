//
//  SHGMapView.m
//  knowYourCity
//
//  Created by Matt Blair on 10/21/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGMapView.h"

#import "EWAMapManager.h"

@interface SHGMapView ()

@property (nonatomic) MKCoordinateRegion initialRegion;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *locationButton;

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation SHGMapView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title region:(MKCoordinateRegion)region navBarMargin:(BOOL)navBar {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _showCalloutAccessories = YES;
        _showCallouts = YES;
        
        self.backgroundColor = [UIColor whiteColor]; // or some kind of transparency?
        
        CGFloat buttonSize = 0.0;
        CGFloat initialY = navBar ? 64.0 : 20.0; // keep out of the way of a status bar
        
        // only create the header if the title is defined
        if (title) {
            
            buttonSize = 44.0;
            
            self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *locationImage;
            
            if (ON_IOS7) {
                
                // display it using our tint color
                locationImage = [[UIImage imageNamed:kLocationButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            } else {
                
                locationImage = [UIImage imageNamed:kLocationButtonImage];
            }
            
            [self.locationButton setImage:locationImage
                                 forState:UIControlStateNormal];
            
            [self.locationButton addTarget:self
                                    action:@selector(recenterMap)
                          forControlEvents:UIControlEventTouchUpInside];
            
            self.locationButton.frame = CGRectMake(0.0, initialY, buttonSize, buttonSize);
            
            [self addSubview:self.locationButton];
            
            [self updateLocationButton];
            
            
            CGFloat titleWidth = self.bounds.size.width - buttonSize*2.0;
            
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonSize, initialY,
                                                                        titleWidth, buttonSize)];
            // should be one line, preferably one word
            self.titleLabel.text = title;
            self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:self.titleLabel];
            
            CGFloat rightButtonX = self.bounds.size.width - buttonSize;
            
            
            self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *closeImage;
            
            if (ON_IOS7) {
                
                // display it using our tint color
                closeImage = [[UIImage imageNamed:kCloseButton] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            } else {
                
                closeImage = [UIImage imageNamed:kCloseButton];
            }
            
            [self.closeButton setImage:closeImage
                              forState:UIControlStateNormal];
            
            [self.closeButton addTarget:self
                                 action:@selector(closeMapView:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            self.closeButton.frame = CGRectMake(rightButtonX, initialY, buttonSize, buttonSize);
            
            [self addSubview:self.closeButton];
        }
        
        // mapview should take up the whole screen, except header/footer
        CGRect mapRect = CGRectMake(0.0, initialY+buttonSize, self.bounds.size.width, self.bounds.size.height - buttonSize);
        
        self.mapView = [[MKMapView alloc] initWithFrame:mapRect];
        
        self.mapView.delegate = self;
        
        // set region
        self.initialRegion = region;
        
        self.mapView.region = self.initialRegion;
        
        if (ON_IOS7) {
            self.mapView.showsPointsOfInterest = NO;
        }
        
        [self addSubview:self.mapView];
        
        // footer not handled yet
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(prepareToBeBackgrounded:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)prepareToBeBackgrounded:(NSNotification *)note {
    
    DLog(@"Stopping location tracking");
    
    // Is MKMapView using its own CLLocationManager with
    // pausesLocationUpdatesAutomatically set to YES?
    // i.e. is this happening automatically? Or do we need to manage it?
    
    [self stopTrackingUser];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (MKCoordinateRegion)currentRegion {
    
    if (self.mapView) {
        
        return self.mapView.region;
    } else {
        
        // does it make any sense to return this here?
        return [EWA_MM launchRegion];
    }
}

- (void)addAnnotations:(NSArray *)annotations {
    
    // store these annotations anywhere?
    
    [self.mapView addAnnotations:annotations];
    
    // reposition map automatically?
}

- (void)showUser {
    
    // in iOS 7, turning this on automatically centers the map on the user
    // this is NOT what we want
    
    // definitely need to prevent this from happening if they are out of the city
    
    if ([EWA_MM hasValidLocation]) {
        
        self.mapView.showsUserLocation = YES;
    } else {
        DLog(@"Blocked attempt to show user on the map");
    }
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
            
            // I decided it annoys me on iPhones, too, but I might change my mind.
            pinView.animatesDrop = NO;
            
            // This appears as an info button in iOS 7.x
            if (self.showCalloutAccessories) {
                UIButton* rightButton = [UIButton buttonWithType:
                                         UIButtonTypeDetailDisclosure];
                
                pinView.rightCalloutAccessoryView = rightButton;
            }
        }
        
        pinView.canShowCallout = self.showCallouts;
        pinView.pinColor = MKPinAnnotationColorRed;
	}
    
	return pinView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    self.locationButton.enabled = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    DLog(@"Map's center latitude is: %f", mapView.region.center.latitude);
    DLog(@"Map's center longitude is: %f", mapView.region.center.longitude);
    DLog(@"Map's latitude delta is: %f", mapView.region.span.latitudeDelta);
    DLog(@"Map's longitude delta is: %f", mapView.region.span.longitudeDelta);
    
    // check location availability here? throttle these calls?
    
    [self updateLocationButton];
}

#pragma mark - Managing Location

- (void)setShowLocationButton:(BOOL)showLocation {
    
    _showLocationButton = showLocation;
    
    self.locationButton.hidden = _showLocationButton;
}

- (void)updateLocationButton {
    
    // in 1.0, this probably only turns on and off
    // in later versions, imitate the stateful location behavior in Maps app, i.e.
    // * solid if map is centered on user
    // * outlined if user location is enabled but map is not centered on user
    // * disabled if location services are disabled
    
    if (self.locationButton) {

#warning Remove if not functional
        // this isn't a good way to do this, because it blocks use of the
        // location button to return to primary region if the location is not available
        //self.locationButton.enabled = [EWA_MM hasValidLocation];
    }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
    DLog(@"Will locate user");
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading
                             animated:YES];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    // disable the user location button
    
    // show an alert?
}

- (void)stopTrackingUser {
    
    self.mapView.showsUserLocation = NO;
}


#pragma mark - Responding to User Actions

- (void)closeMapView:(id)sender {
    
    [self stopTrackingUser];
    
    [self.delegate mapView:self didFinishWithSelectedID:NSNotFound ofType:SHGSearchResultTypeStory];
}

- (void)recenterMap {
    
    // if available, combine user location and initial region?
    
    if ([EWA_MM hasValidLocation]) {
        
        if (!self.mapView.userLocationVisible) {
            // move map to center on user
            DLog(@"User not visible. Should re-center on user?");
            
            // user the user location from the map view? Or from CL directly?
        }
        
        // make sure user is displayed on map
        
        // move to location that combines user and dataRegion
        
        self.mapView.showsUserLocation = YES; // does this auto-animate to center on user?
        
        [self.mapView setRegion:[EWA_MM regionForLocationAndDataRegion:self.dataRegion]
                       animated:YES];
        
    } else {
        
        [self.mapView setRegion:self.initialRegion
                       animated:YES];
    }
    
    self.locationButton.enabled = NO;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self stopTrackingUser];
    
    // cast annotation to pull relevant data
    SHGMapAnnotation *tappedAnnotation = (SHGMapAnnotation *)view.annotation;
    
    DLog(@"Would handle tap on %@", [tappedAnnotation description]);
    
    NSUInteger tappedID = [tappedAnnotation.contentID unsignedIntegerValue];
    
    [self.delegate mapView:self didFinishWithSelectedID:tappedID ofType:tappedAnnotation.annotationType];
}

@end
