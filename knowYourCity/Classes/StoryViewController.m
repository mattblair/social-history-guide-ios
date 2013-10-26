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

@property (nonatomic) BOOL metadataVisible;

@property (strong, nonatomic) UIBarButtonItem *shareButton;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *mainPhoto;

@property (strong, nonatomic) UIButton *metadataButton;
@property (strong, nonatomic) UIView *mediaMetadataView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (strong, nonatomic) EWAAudioPlayerView *theAudioPlayerView;

@property (strong, nonatomic) UILabel *summaryLabel;

@property (strong, nonatomic) UILabel *guestLabel;
@property (strong, nonatomic) GuestStubView *guestView;

@property (strong, nonatomic) UIView *moreInfoView;

@end

@implementation StoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _metadataVisible = NO;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"Story", @"Title for Story View Controller");
    
    // to hide background image on nav bar on iOS 6?
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // add share button
    
    self.shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kActionButton]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(showShareSheet)];
    
    self.shareButton.accessibilityLabel = NSLocalizedString(@"Share this story", @"Accessibility label for story sharing button");
    
    self.navigationItem.rightBarButtonItem = self.shareButton;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    // layout content -- mediaType will drive this
    
    self.yForNextView = 10.0;
    
    KYCStoryMediaType mediaType = [[self.storyData objectForKey:kContentMediaTypeKey] unsignedIntegerValue];
    
    switch (mediaType) {
            
        case KYCStoryMediaTypePhotoInterview: {
            
            // test validity of imageName here, too?
            
            NSString *imageName = [self.storyData objectForKey:kStoryImageKey];
            
            if ([imageName length] > 0) {
                
                
                self.mainPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
                
                [self.mainPhoto setImageWithURL:[SHG_DATA urlForPhotoNamed:imageName]
                               placeholderImage:[SHG_DATA photoPlaceholder]];
                
                self.mainPhoto.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(toggleMetadataDisplay)];
                [self.mainPhoto addGestureRecognizer:photoTap];
                
                [self.scrollView addSubview:self.mainPhoto];
                
                self.yForNextView = CGRectGetMaxY(self.mainPhoto.frame) + VERTICAL_SPACER_STANDARD; // was VERTICAL_SPACER_EXTRA;
                
                // setup caption trigger button ? Or gesture only?
                
                self.metadataButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
                
                CGFloat mdButtonSize = 44.0; // probably depends on graphic
                
                self.metadataButton.frame = CGRectMake(MAIN_PHOTO_WIDTH - mdButtonSize, MAIN_PHOTO_HEIGHT - mdButtonSize,
                                                       mdButtonSize, mdButtonSize);
                
                [self.metadataButton addTarget:self
                                        action:@selector(toggleMetadataDisplay)
                              forControlEvents:UIControlEventTouchUpInside];
                
                [self.scrollView addSubview:self.metadataButton];
                
                [self.scrollView addSubview:[self mediaMetadataView]];
                
            } else {
                
                DLog(@"Image name is missing.");
            }
            
            break;
        }
            
        case KYCStoryMediaTypeNoMedia: {
            
            DLog(@"No media to display");
            break;
        }
        
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
        
        NSDictionary *imageNames = @{
                                     kEWAAudioPlayerPlayImageKey : kPlayButtonImage,
                                     kEWAAudioPlayerPauseImageKey : kPauseButtonImage,
                                     kEWAAudioPlayerThumbImageKey : kThumbButtonImage,
                                     kEWAAudioPlayerUnplayedTrackImageKey : kMaximumTrackImage,
                                     kEWAAudioPlayerPlayedTrackImageKey : kMinimumTrackImage };
        
        self.theAudioPlayerView = [[EWAAudioPlayerView alloc] initWithAudioURL:bundleAudioURL
                                                                        images:imageNames];
        
        // get frame and reset y
        CGRect audioRect = self.theAudioPlayerView.frame;
        audioRect.origin.y = self.yForNextView;
        self.theAudioPlayerView.frame = audioRect;
        self.theAudioPlayerView.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:self.theAudioPlayerView];
        
        // increment y
        self.yForNextView += audioRect.size.height + 10.0;
        
    } else {
        
        DLog(@"Failed to locate audio file named %@.caf in bundle", storyAudio);
    }
    
    // data from the web can be noisy...
    NSString *summaryText = [[self.storyData objectForKey:kStorySummaryKey] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.summaryLabel.text = summaryText;
    self.summaryLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.summaryLabel sizeToFit];
    
    // for layout testing, especially because of extra whitespace
    //self.summaryLabel.backgroundColor = [UIColor yellowColor];
    
    [self.scrollView addSubview:self.summaryLabel];
    
    self.yForNextView = CGRectGetMaxY(self.summaryLabel.frame) + VERTICAL_SPACER_STANDARD; // was VERTICAL_SPACER_EXTRA
    
    // Guest
    NSNumber *guestNumber = [self.storyData objectForKey:kStoryGuestIDKey];
    
    if (guestNumber) {
        
        NSUInteger guestID = [guestNumber unsignedIntegerValue];
        
        // x was DEFAULT_LEFT_MARGIN before iOS 7 re-design
        self.guestView = [[GuestStubView alloc] initWithDictionary:[SHG_DATA dictionaryForGuestID:guestID]
                                                          atOrigin:CGPointMake(0.0, self.yForNextView)];
        
        [self.scrollView addSubview:self.guestView];
        
        self.yForNextView = CGRectGetMaxY(self.guestView.frame) + VERTICAL_SPACER_STANDARD;
    }
    
    // additional media, etc.
    
    // if this is reusable for tidbits or anywhere else,
    // add an initializing method like that for GuestStubView
    // also -- have the view check the dictionary and return nil if there is no data?
    
    NSString *moreInfoTitle = [self.storyData objectForKey:kContentMoreInfoTitleKey];
    
    // some of these titles are noisy, too
    if ([moreInfoTitle length] > 4) {
        
        [self.scrollView addSubview:[self moreInfoView]];
        
        CGFloat moreInfoHeight = self.moreInfoView.frame.size.height;
        self.moreInfoView.frame = CGRectMake(0.0, self.yForNextView, 320.0, moreInfoHeight);
        
        self.yForNextView = CGRectGetMaxY(self.moreInfoView.frame); // no additional spacer
        
    } else { // get rid of that bottom margin that's leftover
        
        self.yForNextView -= VERTICAL_SPACER_STANDARD;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    
    // pre-iOS 7, was adding 20 to the bottom
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView);
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

#pragma mark - Subviews

- (UIView *)mediaMetadataView {
    
    if (!_mediaMetadataView) {
        
        _mediaMetadataView = [[UIView alloc] initWithFrame:self.mainPhoto.frame];
        
        _mediaMetadataView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85];
        UIColor *captionTextColor = [UIColor kycDarkGray];
        
        CGFloat nextLabelY = 5.0;
        
        // setup fields
        
        UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, nextLabelY,
                                                                          DEFAULT_CONTENT_WIDTH, 31.0)];
        captionLabel.numberOfLines = 0;
        captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        captionLabel.text = [self.storyData objectForKey:kContentImageCaptionKey];
        captionLabel.font = [UIFont fontWithName:kBodyFontName size:14.0];
        captionLabel.textColor = captionTextColor;
        
        [captionLabel sizeToFit];
        
        [_mediaMetadataView addSubview:captionLabel];
        
        nextLabelY = CGRectGetMaxY(captionLabel.frame) + 5.0;
        
        // add credit
        
        // see media_credit_markup method of stories_helper.rb for reference
        
        NSString *creditString = [self.storyData objectForKey:kContentImageCreditKey];
        NSString *rawCopyright = [self.storyData objectForKey:kContentImageCopyrightNoticeKey];
        
        NSString *copyrightString = rawCopyright ? rawCopyright : NSLocalizedString(@"Used by Permission", @"Default copyright notice");
        
        // would metadata be shown in the footer of the map?
        NSString *creditPrefix = NO ? @"Map Data" : @"Image";
        
        UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, nextLabelY,
                                                                         DEFAULT_CONTENT_WIDTH, 31.0)];
        creditLabel.textAlignment = NSTextAlignmentRight;
        creditLabel.numberOfLines = 0;
        creditLabel.lineBreakMode = NSLineBreakByWordWrapping;
        creditLabel.text = [NSString stringWithFormat:@"%@: %@ %@", creditPrefix, creditString, copyrightString];
        creditLabel.font = [UIFont fontWithName:kBodyFontName size:12.0];
        creditLabel.textColor = captionTextColor;
        
        [creditLabel sizeToFit];
        
        [_mediaMetadataView addSubview:creditLabel];
        
        nextLabelY = CGRectGetMaxY(creditLabel.frame) + 5.0;
        
        // add weblink? with just a tappable website text?
        
        // resize to bottom of image frame
        
        CGFloat metadataY = self.mainPhoto.frame.size.height - nextLabelY;
        
        _mediaMetadataView.frame = CGRectMake(0.0, metadataY, 320.0, nextLabelY);
        _mediaMetadataView.alpha = _metadataVisible ? 1.0 : 0.0;
        
        UITapGestureRecognizer *mdTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(toggleMetadataDisplay)];
        [_mediaMetadataView addGestureRecognizer:mdTap];
    }
    
    return _mediaMetadataView;
}

- (UIView *)moreInfoView {
    
    if (!_moreInfoView) {
        
        CGFloat moreInfoWidth = 320.0;
        
        _moreInfoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, moreInfoWidth, 100.0)];
        
        //_moreInfoView.backgroundColor = [UIColor kycLightGray];
        UIColor *infoTextColor = [UIColor kycDarkGray];
        
        CGFloat nextLabelY = 0.0;
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, nextLabelY,
                                                                   moreInfoWidth, 22.0)];
        grayView.backgroundColor = infoTextColor;
        [_moreInfoView addSubview:grayView];
        
        UILabel *moreInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, nextLabelY,
                                                                           DEFAULT_CONTENT_WIDTH, 22.0)];
        //moreInfoLabel.backgroundColor = [UIColor kycDarkGray];
        moreInfoLabel.text = NSLocalizedString(@"More Information", @"Title label of the more information section");
        moreInfoLabel.font = [UIFont fontWithName:kTitleFontName size:kBodyFontSize];
        moreInfoLabel.textColor = [UIColor kycLightGray];
        moreInfoLabel.backgroundColor = [UIColor clearColor];
        
        [_moreInfoView addSubview:moreInfoLabel];
        
        nextLabelY = CGRectGetMaxY(moreInfoLabel.frame) + 5.0;
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, nextLabelY,
                                                                          DEFAULT_CONTENT_WIDTH, 31.0)];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.text = [self.storyData objectForKey:kContentMoreInfoTitleKey];
        titleLabel.font = [UIFont fontWithName:kBodyFontName size:kSectionTitleFontSize];
        titleLabel.textColor = infoTextColor;
        
        [titleLabel sizeToFit];
        
        [_moreInfoView addSubview:titleLabel];
        
        nextLabelY = CGRectGetMaxY(titleLabel.frame) + 5.0;
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, nextLabelY,
                                                                         DEFAULT_CONTENT_WIDTH, 31.0)];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.text = [self.storyData objectForKey:kContentMoreInfoDescriptionKey];
        descriptionLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
        descriptionLabel.textColor = infoTextColor;
        
        [descriptionLabel sizeToFit];
        
        [_moreInfoView addSubview:descriptionLabel];
        
        nextLabelY = CGRectGetMaxY(descriptionLabel.frame) + 5.0;
        
        
        NSString *moreInfoURLString = [self.storyData objectForKey:kContentMoreInfoURLKey];
        
        // this field is noisy, so test it.
        if ([moreInfoURLString length] > 8) {
            
            UIButton *urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [urlButton setTitle:NSLocalizedString(@"website", @"Title for website button")
                       forState:UIControlStateNormal];
            
            [urlButton setTitleColor:[UIColor kycRed]
                            forState:UIControlStateNormal];
            
            urlButton.titleLabel.font = [UIFont fontWithName:kBodyFontName
                                                        size:kBodyFontSize];
            
            [urlButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 0.0, 10.0, 10.0)];
            
            [urlButton addTarget:self
                          action:@selector(launchMoreInfoURL)
                forControlEvents:UIControlEventTouchUpInside];
            
            urlButton.frame = CGRectMake(10.0, nextLabelY - 10.0, 60.0, 44.0);
            
            [_moreInfoView addSubview:urlButton];
            
            nextLabelY = CGRectGetMaxY(urlButton.frame);
        }
        
        // reset height
        _moreInfoView.frame = CGRectMake(0.0, 0.0, 320.0, nextLabelY);
    }
    
    return _moreInfoView;
}

#pragma mark - Responding to user gestures

- (void)toggleMetadataDisplay {
    
    // based on alpha, or another state variable?
    
    if (self.metadataVisible) {
        
        self.metadataVisible = NO;
    } else {
        self.metadataVisible = YES;
    }
    
    [UIView animateWithDuration:0.35
                     animations:^{self.mediaMetadataView.alpha = self.metadataVisible ? 1.0 : 0.0;}
                     completion:NULL];
}

- (void)launchMoreInfoURL {
    
    NSString *moreInfoURLString = [self.storyData objectForKey:kContentMoreInfoURLKey];
    
    if (moreInfoURLString) {
        DLog(@"Handing URL off to Safari: %@", moreInfoURLString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:moreInfoURLString]];
    } else {
        DLog(@"No More Info URL in data...");
    }
}

- (void)showShareSheet {
    
    DLog(@"Would show share sheet...");
}

@end
