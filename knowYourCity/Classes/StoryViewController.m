//
//  StoryViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "StoryViewController.h"
#import "EWAAudioPlayerView.h"
#import "GuestStubView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface StoryViewController ()

@property (nonatomic) CGFloat yForNextView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *mainPhoto;
@property (strong, nonatomic) UILabel *captionLabel;

// image credit needed here

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (strong, nonatomic) EWAAudioPlayerView *theAudioPlayerView;

@property (strong, nonatomic) UILabel *summaryLabel;

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
    
    self.title = NSLocalizedString(@"Story", @"Title for Story View Controller");
    
    // to hide background image on nav bar
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // add share button
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    // layout content -- mediaType will drive this
    
    self.yForNextView = 0.0;
    
    KYCStoryMediaType mediaType = [[self.storyData objectForKey:kContentMediaTypeKey] unsignedIntegerValue];
    
    switch (mediaType) {
            
        case KYCStoryMediaTypePhotoInterview: {
            
            self.mainPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.yForNextView, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
            
            NSString *imageName = [self.storyData objectForKey:kStoryImageKey];
            
            [self.mainPhoto setImageWithURL:[SHG_DATA urlForPhotoNamed:imageName]
                           placeholderImage:[SHG_DATA photoPlaceholder]];
            
            [self.scrollView addSubview:self.mainPhoto];
            
            self.yForNextView = CGRectGetMaxY(self.mainPhoto.frame) + VERTICAL_SPACER_EXTRA;
            
            self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
            self.captionLabel.numberOfLines = 0;
            self.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.captionLabel.text = [self.storyData objectForKey:kContentImageCaptionKey];
            self.captionLabel.font = [UIFont fontWithName:kBodyFontName size:14.0];
            
            [self.captionLabel sizeToFit];
            
            [self.scrollView addSubview:self.captionLabel];
            
            self.yForNextView = CGRectGetMaxY(self.mainPhoto.frame) + VERTICAL_SPACER_EXTRA;
            
            // image credit here
            
            break;
        }
            
        case KYCStoryMediaTypeNoMedia:
            DLog(@"No media to display");
            break;
        
        case KYCStoryMediaTypeGeoJSONMap: {
            
            DLog(@"Would show points on the map...");
            
            break;
        }
            
        default:
            DLog(@"Unhandled media type: %d", mediaType);
            break;
    }
    
    // title and subtitle
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [self.storyData objectForKey:kContentTitleKey];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitleLabel.text = [self.storyData objectForKey:kContentSubtitleKey];
    self.subtitleLabel.textColor = [UIColor kycMediumGray];
    self.subtitleLabel.font = [UIFont fontWithName:kTitleFontName size:kBodyFontSize];
    
    [self.subtitleLabel sizeToFit];
    
    [self.scrollView addSubview:self.subtitleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.subtitleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // audio player
    
    NSString *storyAudio = [self.storyData objectForKey:kContentAudioFilenameKey];
    
    // file extension is *not* stored in data
    NSURL *bundleAudioURL = [[NSBundle mainBundle] URLForResource:storyAudio
                                                    withExtension:@"caf"];
    
    if (bundleAudioURL) {
        
        self.theAudioPlayerView = [[EWAAudioPlayerView alloc] initWithAudioURL:bundleAudioURL];
        
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
        
    } else {
        
        DLog(@"Failed to locate audio file named %@.caf in bundle", storyAudio);
    }
    
    // summary text
    
    self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.summaryLabel.text = [self.storyData objectForKey:kStorySummaryKey];
    self.summaryLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.summaryLabel sizeToFit];
    
    [self.scrollView addSubview:self.summaryLabel];
    
    self.yForNextView = CGRectGetMaxY(self.summaryLabel.frame) + VERTICAL_SPACER_EXTRA;
    
    
    // guest list -- allow for multiple
    
    // Guest Label
    self.guestLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.guestLabel.numberOfLines = 1;
    self.guestLabel.text = NSLocalizedString(@"As Told By", @"Heading label for the Guest section of Story View Controller");
    self.guestLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
    
    [self.scrollView addSubview:self.guestLabel];
    
    self.yForNextView = CGRectGetMaxY(self.guestLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // Guests (allow for multiple)
    
    NSDictionary *guestDictionary = @{@"name" : @"Jan Dilg", @"title": @"Independent Historian"};
    
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.theAudioPlayerView) {
        [self.theAudioPlayerView pausePlayback];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
