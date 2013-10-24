//
//  HomeViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeViewController.h"
#import "TidbitListViewController.h"
#import "SHGStaticPageViewController.h"
#import "MapViewController.h"

// temporary, until data loading to Core Data is implemented and populated
// then all data access should move to the singleton Core Data
#import "JSONKit.h"

@interface HomeViewController ()

// temporary -- for access to JSON data
@property (strong, nonatomic) NSArray *themeList;
@property (strong, nonatomic) NSArray *tidbitList;
@property (strong, nonatomic) NSDictionary *seedDictionary;

@property (strong, nonatomic) UITableView *themeTableView;

// toolbar buttons
@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *tidbitButton;
@property (strong, nonatomic) UIBarButtonItem *newsButton;
@property (strong, nonatomic) UIBarButtonItem *infoButton;
@property (strong, nonatomic) UIBarButtonItem *timelineButton; // iPad only? 1.x?

@property (strong, nonatomic) SHGMapView *nearbyMapView;

@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadDataFromJSON];
        //self.themeList = [self.seedDictionary objectForKey:@"themes"];
        self.themeList = [SHG_DATA publishedThemes];
        self.tidbitList = [self.seedDictionary objectForKey:@"tidbits"];
        
        // use this if you are showing standard text in nav bars and back buttons
        //self.title = NSLocalizedString(@"Themes", @"Title for Home View Controller");
        
        // if you don't want a toolbar:
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    // set background just for this nav bar:
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:kNavBarBackgroundiPhone]
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    // or configure header logo:
    //UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kNavAppLogoiPhone] ];
    //self.navigationItem.titleView = logoImage;
    
    self.title = NSLocalizedString(@"Explore", @"Title of list of themes on home view controller.");
    
    self.themeTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                       style:UITableViewStylePlain];
    
    self.themeTableView.dataSource = self;
    self.themeTableView.delegate = self;
    
    // turn off section index, if you use sections
    //self.themeTableView.sectionIndexMinimumDisplayRowCount = 0;
    
    [self.view addSubview:self.themeTableView];
    
    //[self configureToolbar];
    
    // add buttons to the nav bar instead
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
    self.themeTableView.frame = [self.view bounds];
}

// always show the toolbar for this view controller
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // could animate toolbar's return here, but themeTableView frame
    // setting needs to happen after toolbar reappears
    //[self.navigationController setToolbarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.themeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    // Configure the cell...
    
    if (indexPath.row < [self.themeList count]) {
        cell.textLabel.text = [themeDictionary objectForKey:kContentTitleKey];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Not Found.", @"Not found descriptive text.");
        DLog(@"Couldn't convert section %d and row %d into a theme.", indexPath.section, indexPath.row);
    }
    
    //cell.imageView.image = [UIImage imageNamed:[themeDictionary objectForKey:@"thumbnail"]];
    
    cell.textLabel.accessibilityLabel = cell.textLabel.text;
    cell.textLabel.accessibilityHint = NSLocalizedString(@"The name of a theme.", @"Hint for theme name in theme list.");
    
    cell.textLabel.font = [UIFont fontWithName:kTitleFontName size:22.0];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.detailTextLabel.text = [themeDictionary objectForKey:kContentSubtitleKey];
    
    cell.detailTextLabel.font = [UIFont fontWithName:kBodyFontName size:15.0];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // keep them uniform
    return 66.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Tapped section %d and row %d", indexPath.section, indexPath.row);
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    [Flurry logEvent:@"themeSelected" withParameters:@{@"themeTitle" : [themeDictionary objectForKey:kContentTitleKey]}];
    
    ThemeViewController *themeVC = [[ThemeViewController alloc] initWithNibName:nil bundle:nil];
    // sets title to diplay in the nav bar
    //themeVC.title = [themeDictionary objectForKey:@"title"];
    themeVC.themeDictionary = themeDictionary;
    [self.navigationController pushViewController:themeVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Loading JSON (temporary)

- (void)loadDataFromJSON {
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:kSeedJSONFilename ofType:@"json"];
	
	NSError *fileLoadError = nil;
	
    NSData *seedJSONData = [NSData dataWithContentsOfFile:filepath
                                                  options:NSDataReadingUncached
                                                    error:&fileLoadError];
    
    if (!seedJSONData) {
        NSLog(@"Loading JSON File Failed: %@, %@", fileLoadError, [fileLoadError userInfo]);
    }
    
    NSError *jsonDeserializeError = nil;
    
    self.seedDictionary = [seedJSONData objectFromJSONDataWithParseOptions:JKParseOptionStrict
                                                                     error:&jsonDeserializeError];
    
    if (!self.seedDictionary) {
        NSLog(@"Loading JSON File Failed: %@, %@", jsonDeserializeError, [jsonDeserializeError userInfo]);
    }
}

#pragma mark - Navigation

- (SHGMapView *)nearbyMapView {
    
    if (!_nearbyMapView) {
        
        // temporary -- this should try to use user location, and only fallback to a default
        CLLocationCoordinate2D defaultCenter = CLLocationCoordinate2DMake(45.505796, -122.678586);
        
        _nearbyMapView = [[SHGMapView alloc] initWithFrame:self.view.bounds
                                                     title:NSLocalizedString(@"Nearby", @"Title of nearby map")
                                                    region:MKCoordinateRegionMakeWithDistance(defaultCenter, 4000.0, 3000.0)
                                                    footer:nil];
        _nearbyMapView.delegate = self;
    }
    
    return _nearbyMapView;
}

- (void)showMap {
    
    //[self showComingSoon:@"Map View is not yet available."];
    
    /*
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mapVC.delegate = self;
    mapVC.dataArray = self.tidbitList;
    [self presentViewController:mapVC animated:YES completion:NULL];
     
    */
    
    [self.view addSubview:self.nearbyMapView];
    
    // temporary -- this should try to use user location, and only fallback to a default
    CLLocationCoordinate2D defaultCenter = CLLocationCoordinate2DMake(45.505796, -122.678586);
    
    MKCoordinateRegion nearbyRegion = MKCoordinateRegionMakeWithDistance(defaultCenter, 4000.0, 3000.0);
    
    [self.nearbyMapView addAnnotations:[SHG_DATA mapAnnotationsOfType:SHGMapAnnotationTypeStory
                                                             inRegion:nearbyRegion
                                                             maxCount:20]];
    
    [UIView animateWithDuration:0.5
                     animations:^{self.nearbyMapView.alpha = 1.0;}
                     completion:NULL];
}

- (void)showAbout {
    
    SHGStaticPageViewController *pageVC = [[SHGStaticPageViewController alloc] initWithNibName:nil
                                                                               bundle:nil];
    
    pageVC.hidesBottomBarWhenPushed = YES; // probably won't be needed
    
    //[self.navigationController pushViewController:aboutVC animated:YES];
    
    [self presentViewController:pageVC animated:YES completion:NULL];
}


#pragma mark - SHGMapViewDelegate Methods

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType {

    [UIView animateWithDuration:0.5
                     animations:^{self.nearbyMapView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         
                         // push if needed
                         if (itemID != NSNotFound) {
                             DLog(@"Would show story with id %d", itemID);
                         }
                     }];
}


#pragma mark - Toolbar (Deprecated?)

- (void)configureToolbar {
    
    // first, create all the buttons you need:
    self.navigationController.toolbar.tintColor = [UIColor kycNavBarColor];
    
    // MapView
    self.mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"103-map"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(showMap)];
    
    self.mapButton.accessibilityLabel = @"Show themes on a map.";
    
    // Tidbits
    
    // 97-puzzle,
    self.tidbitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"179-notepad"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(showTidbits)];
    
    self.tidbitButton.accessibilityLabel = @"Show a list of tidbits";
    
    // Info
    self.infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"123-id-card"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(showAbout)];
    
    self.infoButton.accessibilityLabel = @"Show About Page";
    
    
    // might make more sense to fold this into about section
    // 44-shoebox
    self.newsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"104-index-cards"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(showNews)];
    
    self.newsButton.accessibilityLabel = @"Show project news";
    
	// re-usable flex space (system)
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil
																				   action:nil];
    
    self.navigationController.toolbarHidden = NO;
    
    self.toolbarItems = @[self.infoButton,
                          flexibleSpace,
                          //self.tidbitButton,
                          //flexibleSpace,
                          // should be on right, so map flip button acts as a toggle
                          self.mapButton
                          ];
}

// delayed until 1.1+
- (void)showTidbits {
    
    //[self showComingSoon:@"Tidbits list is not yet available."];
    
    TidbitListViewController *tidbitVC = [[TidbitListViewController alloc] initWithNibName:nil
                                                                                    bundle:nil];
    tidbitVC.tidbitList = self.tidbitList;
    
    tidbitVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:tidbitVC animated:YES];
}

// probably cancelled, unless there will be some type of blog feed for the project
- (void)showNews {
    
    [self showComingSoon:@"Project News is not yet available."];
}

// probably a 1.5 feature?
- (void)showTimeline {
    DLog(@"Not implemented in v1.0");
}

- (void)showComingSoon:(NSString *)thePromise {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
													message:thePromise
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:@"OK", nil];
	[alert show];
}

@end
