//
//  TidbitListViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "TidbitListViewController.h"
#import "TidbitDetailViewController.h"

@interface TidbitListViewController ()

@property (strong, nonatomic) UITableView *tidbitTableView;

@end

@implementation TidbitListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
	
    self.tidbitTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                        style:UITableViewStylePlain];
    
    self.tidbitTableView.dataSource = self;
    self.tidbitTableView.delegate = self;
    
    // turn off section index, if you use sections
    //self.themeTableView.sectionIndexMinimumDisplayRowCount = 0;
    
    [self.view addSubview:self.tidbitTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tidbitTableView.frame = [self.view bounds];
}

// iOS 5.x only
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tidbitList count];
}

- (UITableViewCell *)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    // After Core Data: transform a Tidbit NSManagedObject Subclass into the cell config dictionary
    
    // read more: http://inessential.com/2012/12/31/uitableviewcell_is_not_a_controller
    
    NSDictionary *tidbitDictionary = self.tidbitList[indexPath.row];
    
    if (indexPath.row >= [self.tidbitList count]) {
        
        cell.textLabel.text = NSLocalizedString(@"Not Found.", @"Not found descriptive text.");
        DLog(@"Couldn't convert section %d and row %d into a theme.", indexPath.section, indexPath.row);
        
    } else {
        cell.textLabel.text = [tidbitDictionary objectForKey:@"title"];
    }
    
    NSNumber *mediaTypeNumber = [tidbitDictionary objectForKey:@"mediaType"];
    KYCStoryMediaType mediaType = mediaTypeNumber ? [mediaTypeNumber integerValue] : 0;
    
    cell.imageView.image = [UIImage imageNamed:[KYCSTYLE imageNameForMediaType:mediaType]];
    
    cell.textLabel.accessibilityLabel = cell.textLabel.text;
    cell.textLabel.accessibilityHint = NSLocalizedString(@"Tidbit Title", @"Hint for Tidbit title in tidbit list.");
    
    cell.textLabel.font = [UIFont fontWithName:kBodyFontName size:17.0];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TidbitCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    return [self updateCell:cell atIndexPath:indexPath];
}

// if presented chronologically, might use sections for months. See L&V fragments for example.


#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Tapped section %d and row %d", indexPath.section, indexPath.row);
    
    // push a detail view, based on media type
    
    NSDictionary *tidbitDictionary = self.tidbitList[indexPath.row];
    
    TidbitDetailViewController *tidbitVC = [[TidbitDetailViewController alloc] initWithNibName:nil
                                                                                        bundle:nil];
    
    tidbitVC.tidbitData = tidbitDictionary;
    
    [self.navigationController pushViewController:tidbitVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
