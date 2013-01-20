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

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *themeList;

@property (strong, nonatomic) UITableView *themeTableView;

@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // this array is temporary, until Core Data implemented and populated
        self.themeList = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h"];
        self.title = NSLocalizedString(@"Know Your City", @"App title");
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
    
    // Configure the cell...
    
    if ([self.themeList count] > indexPath.row) {
        cell.textLabel.text = self.themeList[indexPath.row];
    } else {
        cell.textLabel.text = @"Not Found.";
        DLog(@"Couldn't convert section %d and row %d into a theme.", indexPath.section, indexPath.row);
    }
    
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
}


@end
