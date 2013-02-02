//
//  StoryViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "StoryViewController.h"
#import "EWMAudioPlayerView.h"
#import "GuestStubView.h"

@interface StoryViewController ()

@property (nonatomic) CGFloat yForNextView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *mainPhoto;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) EWMAudioPlayerView *theAudioPlayerView;
@property (strong, nonatomic) UILabel *mainTextLabel;

@property (strong, nonatomic) UILabel *guestLabel;
@property (strong, nonatomic) GuestStubView *guestView;
@end

@implementation StoryViewController

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
    
    // add share button
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    // layout content
    self.yForNextView = 0.0;
    
    // image/gallery
    
    self.mainPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.yForNextView, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
    self.mainPhoto.image = [UIImage imageNamed:@"golden-west-ph.jpg"];
    
    [self.scrollView addSubview:self.mainPhoto];
    
    self.yForNextView = CGRectGetMaxY(self.mainPhoto.frame) + VERTICAL_SPACER_EXTRA;
    
    // title
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.titleLabel.text = [self.storyData objectForKey:@"title"];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // audio player
    
    // until Core Data is set up and we have multiple audio files
    NSString *audioFilename = @"kycPlaceholder.mp3";
    
    if ([audioFilename length] > 0) {
        
        // file extension stored in data?
        NSURL *bundleAudioURL = [[NSBundle mainBundle] URLForResource:audioFilename
                                                        withExtension:nil];
        
        self.theAudioPlayerView = [[EWMAudioPlayerView alloc] initWithAudioURL:bundleAudioURL];
        
        // get frame and reset y
        CGRect audioRect = self.theAudioPlayerView.frame;
        audioRect.origin.y = self.yForNextView;
        self.theAudioPlayerView.frame = audioRect;
        self.theAudioPlayerView.backgroundColor = [UIColor whiteColor];
        
        // we'll probably use images for these instead
        self.theAudioPlayerView.thumbColor = [UIColor grayColor];
        self.theAudioPlayerView.minimumTrackColor = [UIColor darkGrayColor];
        self.theAudioPlayerView.maximumTrackColor = [UIColor lightGrayColor];
        
        [self.scrollView addSubview:self.theAudioPlayerView];
        
        // increment y
        self.yForNextView += audioRect.size.height + 10.0;
    }
    
    // main text
    
    self.mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.mainTextLabel.numberOfLines = 0;
    self.mainTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.mainTextLabel.text = [self.storyData objectForKey:@"mainText"];
    self.mainTextLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.mainTextLabel sizeToFit];
    
    [self.scrollView addSubview:self.mainTextLabel];
    
    self.yForNextView = CGRectGetMaxY(self.mainTextLabel.frame) + VERTICAL_SPACER_EXTRA;
    
    
    // guest list -- allow for multiple
    
    // Guest Label
    self.guestLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.guestLabel.numberOfLines = 1;
    self.guestLabel.text = NSLocalizedString(@"As Told By", @"Heading label for the Guest section of Story View Controller");
    self.guestLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
    
    [self.scrollView addSubview:self.guestLabel];
    
    self.yForNextView = CGRectGetMaxY(self.guestLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // Guests (allow for multiple)
    
    NSDictionary *guestDictionary = @{@"name" : @"Guest Name", @"title": @"Title or fact that makes us want to read more."};
    
    self.guestView = [[GuestStubView alloc] initWithDictionary:guestDictionary
                                                      atOrigin:CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView)];
    
    [self.scrollView addSubview:self.guestView];
    
    self.yForNextView = CGRectGetMaxY(self.guestView.frame) + VERTICAL_SPACER_STANDARD;
    
    // additional media, etc.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView + 20.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
