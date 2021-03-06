//
//  HomeViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeViewController.h"
#import "SHGStaticPageViewController.h"
#import "StoryViewController.h"
#import "EWAMapManager.h"

// deferred
#import "TidbitListViewController.h"

// probably deprecated
#import "MapViewController.h"

#define THEME_THUMBNAIL_CELLS NO

@interface HomeViewController ()

// temporary -- for access to JSON data
@property (strong, nonatomic) NSArray *themeList;
@property (strong, nonatomic) NSArray *tidbitList;
@property (strong, nonatomic) NSDictionary *seedDictionary;

@property (strong, nonatomic) UITableView *themeTableView;

// navbar buttons
@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *infoButton;

@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *locationButton;

// possibly deprecated
@property (strong, nonatomic) UIBarButtonItem *tidbitButton;
@property (strong, nonatomic) UIBarButtonItem *newsButton;
@property (strong, nonatomic) UIBarButtonItem *timelineButton; // iPad only? 1.x?

@property (strong, nonatomic) SHGMapView *nearbyMapView;

@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.themeList = [SHG_DATA publishedThemes];
        
        // if you don't want a toolbar:
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    self.title = NSLocalizedString(@"Themes", @"Title of list of themes on home view controller.");
    
    self.themeTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                       style:UITableViewStylePlain];
    
    self.themeTableView.dataSource = self;
    self.themeTableView.delegate = self;
    [self.view addSubview:self.themeTableView];
    
    self.mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kMapButtonImage]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(showMap)];
    
    self.mapButton.accessibilityLabel = @"Show stories on a map.";
    
    self.navigationItem.leftBarButtonItem = self.mapButton;
    
    
    // kInfoButtonDarkImage feels too heavy
    self.infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kInfoButtonLightImage]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(showStaticPages)];
    
    self.infoButton.accessibilityLabel = @"Show the about, contact and donate pages.";
    
    self.navigationItem.rightBarButtonItem = self.infoButton;
    
    
    // could lazy-load these, but the memory savings probably isn't that much
    
    self.listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kThemeListButtonImage  ]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(hideMap)];
    
    self.listButton.accessibilityLabel = @"Show the list of themes.";
    
    self.locationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kLocationButtonImage]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(zoomMapToUser)];
    
    self.locationButton.accessibilityLabel = @"Center the map on your current location, or the middle of the stories.";
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
        
        // Do we need subtitles on the first screen?
        // Or use a custom cell design with all three?
        UITableViewCellStyle cellStyle = THEME_THUMBNAIL_CELLS ? UITableViewCellStyleDefault : UITableViewCellStyleSubtitle;
        
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    if (indexPath.row < [self.themeList count]) {
        cell.textLabel.text = [themeDictionary objectForKey:kContentTitleKey];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Not Found.", @"Not found descriptive text.");
        DLog(@"Couldn't convert section %ld and row %ld into a theme.", (long)indexPath.section, (long)indexPath.row);
    }
    
    cell.textLabel.accessibilityLabel = cell.textLabel.text;
    cell.textLabel.accessibilityHint = NSLocalizedString(@"The name of a theme.", @"Hint for theme name in theme list.");
    
    // was 22.0 when using subtitle instead of image
    cell.textLabel.font = [UIFont fontWithName:kTitleFontName size:20.0]; // 18.0 seems too small
    cell.textLabel.textColor = [UIColor kycRed]; // or blackColor
    
    if (THEME_THUMBNAIL_CELLS) { // these drawings are too detailed to appear as thumbnails
        
        // Use pre-rendered thumbnails that are PNGs, not jpegs?
        NSString *illustrationName = [NSString stringWithFormat:@"%@.jpg", [themeDictionary objectForKey:kThemeImageKey]];
        cell.imageView.image = [UIImage imageNamed:illustrationName];
    } else {
        
        // larger than 13 would need to be multi-line, even without image
        cell.detailTextLabel.text = [themeDictionary objectForKey:kContentSubtitleKey];
        cell.detailTextLabel.font = [UIFont fontWithName:kBodyFontName size:14.0];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // keep them uniform for now
    return 66.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Tapped section %ld and row %ld", (long)indexPath.section, (long)indexPath.row);
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    [SHG_DATA logFlurryEventNamed:kFlurryEventThemeView
                   withParameters:@{ kFlurryParamSlug : [themeDictionary objectForKey:kContentSlugKey] }];
    
    ThemeViewController *themeVC = [[ThemeViewController alloc] initWithNibName:nil bundle:nil];
    // sets title to diplay in the nav bar
    //themeVC.title = [themeDictionary objectForKey:@"title"];
    themeVC.themeDictionary = themeDictionary;
    [self.navigationController pushViewController:themeVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Show Static Pages

- (void)showStaticPages {
    
    SHGStaticPageViewController *pageVC = [[SHGStaticPageViewController alloc] initWithNibName:nil
                                                                                        bundle:nil];
    pageVC.hidesBottomBarWhenPushed = YES; // probably won't be needed
    [self presentViewController:pageVC animated:YES completion:NULL];
}


#pragma mark - Map View

- (SHGMapView *)nearbyMapView {
    
    if (!_nearbyMapView) {
        
        _nearbyMapView = [[SHGMapView alloc] initWithFrame:self.view.bounds
                                                     title:nil // title and buttons moved to nav bar
                                                    region:[EWA_MM currentOrLaunchRegion]
                                              navBarMargin:YES];
        _nearbyMapView.delegate = self;
    }
    
    return _nearbyMapView;
}

- (void)showMap {
    
    self.navigationItem.title = NSLocalizedString(@"Explore", @"Nav title when viewing map of nearby stories");
    self.navigationItem.leftBarButtonItem = self.listButton;
    self.navigationItem.rightBarButtonItem = self.locationButton;
    
    [self.view addSubview:self.nearbyMapView];
        
    [self.nearbyMapView addAnnotations:[SHG_DATA mapAnnotationsOfType:SHGSearchResultTypeStory
                                                             inRegion:self.nearbyMapView.currentRegion
                                                             maxCount:45]];
    
    // set the center, which will be used for recentering
    self.nearbyMapView.dataRegion = [EWA_MM launchRegion];
    
    [self.nearbyMapView showUser];
    
    // recenter on completion to avoid a user-centered map
    [UIView animateWithDuration:0.5
                     animations:^{self.nearbyMapView.alpha = 1.0;}
                     completion:^(BOOL finished){[self.nearbyMapView recenterMap];}];
}

// to close without a selection
- (void)hideMap {
    
    [self mapView:nil didFinishWithSelectedID:NSNotFound ofType:NSNotFound];
}

- (void)zoomMapToUser {
    
    DLog(@"Would tell the map view to zoom.");
    
    [self.nearbyMapView recenterMap];
}


#pragma mark - Show a Story

- (void)showStoryWithID:(NSUInteger)storyID {
    
    NSDictionary *storyDictionary = [SHG_DATA dictionaryForStoryID:storyID];
    
    if (storyDictionary) {
        
        [SHG_DATA logFlurryEventNamed:kFlurryEventStoryViewFromMap
                       withParameters:@{ kFlurryParamSlug : [storyDictionary objectForKey:kContentSlugKey] }];
        
        StoryViewController *storyVC = [[StoryViewController alloc] initWithNibName:nil bundle:nil];
        
        storyVC.storyData = storyDictionary;
        
        [self.navigationController pushViewController:storyVC animated:YES];
        
    } else {
        
        DLog(@"No story found for id %lu", (unsigned long)storyID);
    }
}


#pragma mark - SHGMapViewDelegate Methods

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType {

    self.navigationItem.title = NSLocalizedString(@"Themes", @"Nav title when viewing theme list");
    self.navigationItem.leftBarButtonItem = self.mapButton;
    self.navigationItem.rightBarButtonItem = self.infoButton;
    
    if (self.nearbyMapView) {
        [EWA_MM stopTrackingLocation];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{self.nearbyMapView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         
                         // push if needed
                         if (itemID != NSNotFound) {
                             DLog(@"Would show story with id %lu", (unsigned long)itemID);
                             
                             [self showStoryWithID:itemID];
                         }
                     }];
}


#pragma mark - Toolbar (Deprecated?)

- (void)configureToolbar {
    
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
                                                      action:@selector(showStaticPages)];
    
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
    DLog(@"Convert to UIAlertController if needed in the future.");
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
													message:thePromise
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:@"OK", nil];
	[alert show];
    */
}

@end
