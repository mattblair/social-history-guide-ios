//
//  GuestViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 10/29/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "GuestViewController.h"

@interface GuestViewController ()

@property (nonatomic) CGFloat yForNextView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *guestPhoto;

@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bioLabel;

@property (strong, nonatomic) UILabel *websiteSectionLabel;
@property (strong, nonatomic) UILabel *websiteLabel;

@end

@implementation GuestViewController

- (void)loadView {
    
    [super loadView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [self.guestData objectForKey:kGuestImageKey]];
    
    // Most of these are low-res, so don't worry about Retina
    UIImage *guestImage = [UIImage imageNamed:imageName];
    
    if (guestImage) {
        
        self.guestPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
        
        self.guestPhoto.image = guestImage;
        
        [self.scrollView addSubview:self.guestPhoto];
        
        self.yForNextView = CGRectGetMaxY(self.guestPhoto.frame) + VERTICAL_SPACER_STANDARD; // was VERTICAL_SPACER_EXTRA;
        
    } else {
        
        DLog(@"Image name is missing.");
    }
    
    CGFloat buttonSize = 44.0;
    
    CGRect nameRect = CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH - buttonSize, 31.0);
    
    self.nameLabel = [[UILabel alloc] initWithFrame:nameRect];
    self.nameLabel.text = [self.guestData objectForKey:kGuestNameKey];
    self.nameLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    
    [self.nameLabel sizeToFit];
    
    [self.scrollView addSubview:self.nameLabel];
    
    
    // close button (under image. A red x over a person's photo would look weird...)
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *closeImage;
    
    if (ON_IOS7) {
        
        // display it using our tint color
        closeImage = [[UIImage imageNamed:kCloseButton] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        
        closeImage = [UIImage imageNamed:kCloseButton];
    }
    
    [self.closeButton setImage:closeImage
                      forState:UIControlStateNormal];
    
    [self.closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton.frame = CGRectMake(self.scrollView.frame.size.width - buttonSize,
                                        self.yForNextView - 11.0,
                                        buttonSize, buttonSize);
    
    [self.closeButton setImageEdgeInsets:UIEdgeInsetsMake(11.0, 11.0, 11.0, 11.0)];
    
    [self.scrollView addSubview:self.closeButton];
    
    
    self.yForNextView += self.nameLabel.frame.size.height + VERTICAL_SPACER_STANDARD;
    
    
    CGRect titleRect = CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH - buttonSize, 31.0);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    self.titleLabel.text = [self.guestData objectForKey:kGuestTitleKey];
    self.titleLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    self.titleLabel.textColor = [UIColor kycMediumGray];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView += self.titleLabel.frame.size.height + VERTICAL_SPACER_STANDARD;
    
    
    CGRect bioRect = CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0);
    
    self.bioLabel = [[UILabel alloc] initWithFrame:bioRect];
    self.bioLabel.text = [self.guestData objectForKey:kGuestBiographyKey];
    self.bioLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    self.bioLabel.numberOfLines = 0;
    self.bioLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bioLabel.backgroundColor = [UIColor clearColor];
    
    [self.bioLabel sizeToFit];
    
    [self.scrollView addSubview:self.bioLabel];
    
    self.yForNextView += self.bioLabel.frame.size.height + VERTICAL_SPACER_STANDARD;
    
    // quote (only two have this so far...)
    
    // guest url and guest url text
    NSString *guestURLString = [self.guestData objectForKey:kGuestURLKey];
    NSString *guestURLTextString = [self.guestData objectForKey:kGuestURLTextKey];
    
    if ([guestURLString length] > 1 && [guestURLTextString length] > 4) {
        
        self.websiteSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 25.0)];
        
        self.websiteSectionLabel.text = NSLocalizedString(@"Website", @"Title of website section of guest detail view");
        self.websiteSectionLabel.font = [UIFont fontWithName:kTitleFontName
                                                        size:kBodyFontSize];
        
        [self.scrollView addSubview:self.websiteSectionLabel];
        
        self.yForNextView += self.websiteSectionLabel.frame.size.height + VERTICAL_SPACER_STANDARD;
        
        
        self.websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 44.0)];
        
        self.websiteLabel.textColor = [UIColor kycRed];
        self.websiteLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.websiteLabel.numberOfLines = 0;
        self.websiteLabel.text = guestURLTextString;
        self.websiteLabel.font = [UIFont fontWithName:kBodyFontName
                                                 size:kBodyFontSize];
        
        [self.websiteLabel sizeToFit];
        
        // probably needs to be multi line
        
        self.websiteLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(launchURL:)];
        
        [self.websiteLabel addGestureRecognizer:websiteTap];
        
        [self.scrollView addSubview:self.websiteLabel];
        
        self.yForNextView += self.websiteLabel.frame.size.height + VERTICAL_SPACER_STANDARD;
    }
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(close:)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.scrollView flashScrollIndicators];
    
    // Since most of the guest photos are dark, black text looks crappy on top of them...
    if (ON_IOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                    animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (ON_IOS7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Respone to User Taps

- (void)launchURL:(id)sender {
    
    NSString *moreInfoURLString = [self.guestData objectForKey:kGuestURLKey];
    
    if (moreInfoURLString) {
        DLog(@"Handing URL off to Safari: %@", moreInfoURLString);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:moreInfoURLString]];
    } else {
        DLog(@"No More Info URL in data...");
    }
}

- (void)close:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
}

@end
