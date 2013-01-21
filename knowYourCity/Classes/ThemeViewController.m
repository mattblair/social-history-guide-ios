//
//  ThemeViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()

@property (strong, nonatomic) UIImageView *themeGraphic;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ThemeViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // to hide background image on nav bar
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    // add this to a scrollview, or the header/footer of a table view?
    
    // Theme illustration
    
    self.themeGraphic = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 240.0)];
    self.themeGraphic.image = [UIImage imageNamed:@"theme_placeholder"];
    
    [self.view addSubview:self.themeGraphic];
    
    
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 250.0, 300.0, 70.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.text = [self.themeDictionary objectForKey:@"title"];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    // resize
    
    [self.view addSubview:self.titleLabel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
