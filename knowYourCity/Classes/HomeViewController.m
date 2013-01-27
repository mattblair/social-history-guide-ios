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

// temporary, until data loading to Core Data is implemented and populated
#import "JSONKit.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *themeList;
@property (strong, nonatomic) NSDictionary *seedDictionary; // temporary
@property (strong, nonatomic) UITableView *themeTableView;

// toolbar buttons
@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *tidbitButton;
@property (strong, nonatomic) UIBarButtonItem *newsButton;
@property (strong, nonatomic) UIBarButtonItem *infoButton;
@property (strong, nonatomic) UIBarButtonItem *timelineButton;

@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadDataFromJSON];
        self.themeList = [self.seedDictionary objectForKey:@"themes"];
        
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:kNavBarBackgroundiPhone]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    // or configure header logo:
    //UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kNavAppLogoiPhone] ];
    //self.navigationItem.titleView = logoImage;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    
    self.themeTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                       style:UITableViewStylePlain];
    
    self.themeTableView.dataSource = self;
    self.themeTableView.delegate = self;
    
    // turn off section index, if you use sections
    //self.themeTableView.sectionIndexMinimumDisplayRowCount = 0;
    
    [self.view addSubview:self.themeTableView];
    
    [self configureToolbar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.themeTableView.frame = [self.view bounds];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    // Configure the cell...
    
    if ([self.themeList count] > indexPath.row) {
        cell.textLabel.text = [themeDictionary objectForKey:@"title"];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Not Found.", @"Not found descriptive text.");
        DLog(@"Couldn't convert section %d and row %d into a theme.", indexPath.section, indexPath.row);
    }
    
    cell.imageView.image = [UIImage imageNamed:[themeDictionary objectForKey:@"thumbnail"]];
    
    cell.textLabel.accessibilityLabel = cell.textLabel.text;
    cell.textLabel.accessibilityHint = NSLocalizedString(@"The name of a theme.", @"Hint for theme name in theme list.");
    
    cell.textLabel.font = [UIFont fontWithName:kBodyFontName size:17.0];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Tapped section %d and row %d", indexPath.section, indexPath.row);
    
    
    NSDictionary *themeDictionary = self.themeList[indexPath.row];
    
    // switch this to a new intializer which accepts a theme object?
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


#pragma mark - Toolbar

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
    
    self.tidbitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"97-puzzle"]
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
    self.newsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"44-shoebox"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(showNews)];
    
    self.newsButton.accessibilityLabel = @"Show project news";
    
	// re-usable flex space (system)
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil
																				   action:nil];    
            
    self.navigationController.toolbarHidden = NO;
    
    self.toolbarItems = [NSArray arrayWithObjects:
                         self.mapButton,
                         flexibleSpace,
                         self.tidbitButton,
                         flexibleSpace,
                         self.infoButton,
                         flexibleSpace,
                         self.newsButton,
                         nil];
}

- (void)showMap {
    
    [self showComingSoon:@"Map View is not yet available."];
}

- (void)showTidbits {
    
    [self showComingSoon:@"Tidbits list is not yet available."];
}

- (void)showAbout {
    
    [self showComingSoon:@"About Page is not yet available."];
}

- (void)showNews {
    
    [self showComingSoon:@"Project News is not yet available."];
}

// probably a 1.5 feature?
- (void)showTimeline {
    DLog(@"Not implemented in v1.0?");
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
