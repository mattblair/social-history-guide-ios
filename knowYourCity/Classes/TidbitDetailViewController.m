//
//  TidbitDetailViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "TidbitDetailViewController.h"

@interface TidbitDetailViewController ()

@property (nonatomic) CGFloat yForNextView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation TidbitDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    // layout content -- mediaType will drive this
    
    self.yForNextView = 0.0;
    
    // image/gallery, if available
    
    NSString *imageName = [self.tidbitData objectForKey:@"image"];
    
    if ([imageName length] > 0) {
    
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.yForNextView, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
        self.photoView.image = [UIImage imageNamed:imageName];
        
        [self.scrollView addSubview:self.photoView];
        
        self.yForNextView = CGRectGetMaxY(self.photoView.frame) + VERTICAL_SPACER_EXTRA;        
    } else {
        self.yForNextView = VERTICAL_SPACER_STANDARD;
    }
    
    // title
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.text = [self.tidbitData objectForKey:@"title"];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // main body text
    
    NSString *textFromJSON = [self.tidbitData objectForKey:@"text"];
    
    // obviously temporary, until we have data
    NSString *tidbitText = textFromJSON ? : @"(Tidbits are little \'bites\' of information we'll release over time – maybe 6 to 10 a month. Each one is categorized by theme, like a story, but they are much smaller than stories, and have only a single item of text or sound or an image.)";
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.text = tidbitText;
    self.textLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.textLabel sizeToFit];
    
    [self.scrollView addSubview:self.textLabel];
    
    self.yForNextView = CGRectGetMaxY(self.textLabel.frame) + VERTICAL_SPACER_STANDARD;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView + 20.0);
}

@end
