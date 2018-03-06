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
        
        // TODO: switch all this to Auto Layout
        //CGFloat statusBarAllowance = ON_IOS7 ? 20.0 : 0.0;
        CGFloat statusBarAllowance = 20.0;
        // should the YES return value be 44.0 + statusBarAllowance ? Magic #s -- blech.
        CGFloat initialY = navBar ? 64.0 : statusBarAllowance;
        
        // only create the header if the title is defined
        if (title) {
            
            buttonSize = 44.0;
            
            self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *locationImage = [[UIImage imageNamed:kLocationButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [self.locationButton setImage:locationImage
                                 forState:UIControlStateNormal];
            
            [self.locationButton addTarget:self
                                    action:@selector(recenterMap)
                          forControlEvents:UIControlEventTouchUpInside];
            
            self.locationButton.frame = CGRectMake(0.0, initialY, buttonSize, buttonSize);
            
            [self addSubview:self.locationButton];
            
            
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
            
            UIImage *closeImage = [[UIImage imageNamed:kCloseButton] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
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
        
        self.initialRegion = region;
        
        self.mapView.region = self.initialRegion;
        self.mapView.showsPointsOfInterest = NO;
        
        [self addSubview:self.mapView];
        
        // footer not handled yet
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleBackgrounding:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showUser)
                                                     name:kLocationPermissionGrantedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTrackingUser)
                                                     name:kLocationPermissionRefusedNotification
                                                   object:nil];
        
        [EWA_MM verifyOrStartLocationUpdates];
    }
    return self;
}

- (void)handleBackgrounding:(NSNotification *)note {
    
    DLog(@"Stopping location tracking");
    
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
    
    // permissions check is built in
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
        pinView.pinTintColor = [MKPinAnnotationView redPinColor];
	}
    
	return pinView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    DLog(@"Map's center latitude is: %f", mapView.region.center.latitude);
    DLog(@"Map's center longitude is: %f", mapView.region.center.longitude);
    DLog(@"Map's latitude delta is: %f", mapView.region.span.latitudeDelta);
    DLog(@"Map's longitude delta is: %f", mapView.region.span.longitudeDelta);
}


#pragma mark - Managing Location

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
    DLog(@"Will locate user");
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading
                             animated:YES];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    // hiding is more effective than setting enabled to NO, because of the color
    self.locationButton.hidden = YES;
}

- (void)stopTrackingUser {
    
    self.mapView.showsUserLocation = NO;
}


#pragma mark - Responding to User Actions

- (void)closeMapView:(id)sender {
    
    [self stopTrackingUser];
    
    [EWA_MM stopTrackingLocation];
    
    [self.delegate mapView:self didFinishWithSelectedID:NSNotFound ofType:SHGMapAnnotationTypeStory];
}

- (void)recenterMap {
    
    if ([EWA_MM hasValidLocation]) {
        
        // move to location that combines user and dataRegion
        
        self.mapView.showsUserLocation = YES;
        
        [self.mapView setRegion:[EWA_MM regionForUserLocationAndDataRegion:self.dataRegion]
                       animated:YES];
    } else {
        
        [self.mapView setRegion:self.initialRegion
                       animated:YES];
    }
    
    // Leave location enabled all the time. Better experience.
    //self.locationButton.enabled = NO;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self stopTrackingUser];
    
    // cast annotation to pull relevant data
    SHGMapAnnotation *tappedAnnotation = (SHGMapAnnotation *)view.annotation;
    
    DLog(@"Handle tap on %@", tappedAnnotation);
    
    NSUInteger tappedID = [tappedAnnotation.contentID unsignedIntegerValue];
    
    [self.delegate mapView:self didFinishWithSelectedID:tappedID ofType:tappedAnnotation.annotationType];
}

@end
