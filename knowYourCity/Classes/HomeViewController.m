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

@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadDataFromJSON];
        self.themeList = [self.seedDictionary objectForKey:@"themes"];
        
        //self.title = NSLocalizedString(@"Know Your City", @"App title");
        self.title = NSLocalizedString(@"Themes", @"Title for Home View Controller");
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kNavAppLogoiPhone] ];
    self.navigationItem.titleView = logoImage;
    
    self.themeTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                       style:UITableViewStylePlain];
    
    self.themeTableView.dataSource = self;
    self.themeTableView.delegate = self;
    
    // turn off section index, if you use sections
    //self.themeTableView.sectionIndexMinimumDisplayRowCount = 0;
    
    [self.view addSubview:self.themeTableView];
    
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
    themeVC.title = [themeDictionary objectForKey:@"title"];
    [self.navigationController pushViewController:themeVC animated:YES];
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

@end
