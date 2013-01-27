//
//  ThemeViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "ThemeViewController.h"
#import "StoryStubView.h"
#import "StoryViewController.h"
#import "GuestStubView.h"

@interface ThemeViewController ()

@property (nonatomic) CGFloat yForNextView;

// could use a UITableView here, but it would be more header/footer than cells, so that seems kind of restricting
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *themeGraphic;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UILabel *guestLabel;
@property (strong, nonatomic) GuestStubView *guestView;

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // if you don't want a toolbar:
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // to hide background image on nav bar
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // add share button
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    // layout content
    self.yForNextView = 0.0;
    
    // Theme illustration
    
    self.themeGraphic = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.yForNextView, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
    self.themeGraphic.image = [UIImage imageNamed:@"theme_placeholder"];
    
    [self.scrollView addSubview:self.themeGraphic];
    
    self.yForNextView = CGRectGetMaxY(self.themeGraphic.frame) + VERTICAL_SPACER_EXTRA;
    
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.text = [self.themeDictionary objectForKey:@"title"];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // introduction
    
    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.introLabel.numberOfLines = 0;
    self.introLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.introLabel.text = [self.themeDictionary objectForKey:@"introduction"];
    self.introLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.introLabel sizeToFit];
    
    [self.scrollView addSubview:self.introLabel];
    
    self.yForNextView = CGRectGetMaxY(self.introLabel.frame) + VERTICAL_SPACER_EXTRA;
    
    // Stories label? Does this section need to be titled?
    
    // Stories buttons (will use a UIView subclass)
    
    NSArray *fakeStories = [self.themeDictionary objectForKey:@"stories"];
    
    NSUInteger storyCounter = 0;
    
    for (NSString *storyName in fakeStories) {
        // draw a button
        
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [aButton setTintColor:[UIColor lightGrayColor]];
        [aButton setTitle:storyName forState:UIControlStateNormal];
        [aButton setTag:STORY_TAG_OFFSET + storyCounter];
        [aButton addTarget:self action:@selector(handleStorySelection:) forControlEvents:UIControlEventTouchUpInside];
        
        aButton.frame = CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 44.0);
        
        [self.scrollView addSubview:aButton];
        
        self.yForNextView = CGRectGetMaxY(aButton.frame) + VERTICAL_SPACER_STANDARD;
        
        storyCounter++;
    }
    
    // Guest Label
    
    // title
    self.guestLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.guestLabel.numberOfLines = 1;
    self.guestLabel.text = NSLocalizedString(@"Guest", @"Heading label for the Guest section of Theme View Controller");
    self.guestLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
    
    [self.scrollView addSubview:self.guestLabel];
    
    self.yForNextView = CGRectGetMaxY(self.guestLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // Guests (allow for multiple)
    
    NSDictionary *guestDictionary = @{@"name" : @"Guest Name", @"title": @"Title or fact that makes us want to read more."};
    
    self.guestView = [[GuestStubView alloc] initWithDictionary:guestDictionary
                                                      atOrigin:CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView)];
    
    [self.scrollView addSubview:self.guestView];
    self.yForNextView = CGRectGetMaxY(self.guestView.frame) + VERTICAL_SPACER_STANDARD;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    // use a define for iPad in the future
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView + 20.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Respond to User Actions

- (void)handleStorySelection:(id)sender {
    
    // temporary, pending UIView subclass with real identifier as property
    UIView *selectedView = (UIView *)sender;
    NSUInteger selectedStoryIndex = selectedView.tag - STORY_TAG_OFFSET;
    
    // push a story VC for that story
    
    DLog(@"Would show story #%d", selectedStoryIndex);
    
    StoryViewController *storyVC = [[StoryViewController alloc] initWithNibName:nil bundle:nil];
    
    NSArray *fakeStories = [self.themeDictionary objectForKey:@"stories"];
    NSString *introText = @"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    storyVC.storyData = @{@"title" : fakeStories[selectedStoryIndex], @"mainText" : introText};
    
    [self.navigationController pushViewController:storyVC animated:YES];
}

@end
