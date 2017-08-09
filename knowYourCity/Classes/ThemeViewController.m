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
#import "SHGMapAnnotation.h"

@interface ThemeViewController ()

@property (nonatomic) CGFloat yForNextView;

@property (nonatomic) NSUInteger themeID;

// could use a UITableView here, but it would be more header/footer than cells, so that seems kind of restricting
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIImageView *themeGraphic;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) NSArray *relatedStories;

@property (strong, nonatomic) SHGMapView *storyMapView;

@property (strong, nonatomic) UIButton *mapButton;

@property (strong, nonatomic) UIActionSheet *sharingMenu;

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
    
    self.title = NSLocalizedString(@"Theme", @"Title of Theme View Controller");
    
    self.themeID = [[self.themeDictionary objectForKey:kThemeIDKey] unsignedIntegerValue];
    
    // to hide background image on nav bar
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    // keep this around to show difference between sytem and kbb buttons
//    self.sharingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
//                                                                       target:self
//                                                                       action:@selector(showSharingMenu:)];
    
    
    self.shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kActionButton]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(showActivityViewController)];
    
    self.shareButton.accessibilityLabel = NSLocalizedString(@"Share this story", @"Accessibility label for story sharing button");
    
    self.navigationItem.rightBarButtonItem = self.shareButton;
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    // layout content
    self.yForNextView = 0.0;
    
    // Theme illustration
    
    self.themeGraphic = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.yForNextView, MAIN_PHOTO_WIDTH, MAIN_PHOTO_HEIGHT)];
    NSString *illustrationName = [NSString stringWithFormat:@"%@.jpg", [self.themeDictionary objectForKey:kThemeImageKey]];
    self.themeGraphic.image = [UIImage imageNamed:illustrationName];
    
    [self.scrollView addSubview:self.themeGraphic];
    
    self.yForNextView = CGRectGetMaxY(self.themeGraphic.frame) + VERTICAL_SPACER_EXTRA;
    
    // Native stories doesn't have any mappable stories within standard data region for v1.0
    // Is this too expensive to run every time? Just hard code instead?!
    
    BOOL hasAnnotations = [SHG_DATA countOfValidStoryAnnotationsForThemeID:self.themeID] > 0;
    
    CGFloat mapButtonSize = hasAnnotations ? 44.0 : 0.0;
    
    // title and map button should have the same top y
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView,
                                                                DEFAULT_CONTENT_WIDTH - mapButtonSize, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [self.themeDictionary objectForKey:kContentTitleKey];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    if (hasAnnotations) {
        
        self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        /*
        UIImage *pinImage;
        
        if (ON_IOS7) {
            
            // display it using our tint color
            pinImage = [[UIImage imageNamed:kMapPinButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            
            pinImage = [UIImage imageNamed:kMapPinButtonImage];
        }
        */
        
        UIImage *pinImage = [[UIImage imageNamed:kMapPinButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self.mapButton setImage:pinImage
                        forState:UIControlStateNormal];
        
        [self.mapButton addTarget:self
                           action:@selector(showMap)
                 forControlEvents:UIControlEventTouchUpInside];
        
        // was y + 4. y + 15 aligns with the baseline of the subtitle, if title is one line.
        self.mapButton.frame = CGRectMake(self.view.bounds.size.width - mapButtonSize, self.yForNextView + 12.0,
                                          mapButtonSize, mapButtonSize);
        
        [self.scrollView addSubview:self.mapButton];
    }
    
    
    // after using the y value for the map button, we want the subtitle to be
    // just under  the title and not pushed down by the map button
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView,
                                                                   DEFAULT_CONTENT_WIDTH - mapButtonSize, 31.0)];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitleLabel.text = [self.themeDictionary objectForKey:kContentSubtitleKey];
    self.subtitleLabel.font = [UIFont fontWithName:kTitleFontName size:kBodyFontSize];
    self.subtitleLabel.textColor = [UIColor kycMediumGray];
    
    [self.subtitleLabel sizeToFit];
    
    [self.scrollView addSubview:self.subtitleLabel];
    
    CGFloat nextY = MAX(CGRectGetMaxY(self.subtitleLabel.frame), CGRectGetMaxY(self.mapButton.frame));
    self.yForNextView = nextY + VERTICAL_SPACER_STANDARD;
    
    // introduction
    
    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.introLabel.numberOfLines = 0;
    self.introLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.introLabel.text = [self.themeDictionary objectForKey:kThemeSummaryKey];
    self.introLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.introLabel sizeToFit];
    
    [self.scrollView addSubview:self.introLabel];
    
    self.yForNextView = CGRectGetMaxY(self.introLabel.frame) + VERTICAL_SPACER_EXTRA;
    
    
    self.relatedStories = [SHG_DATA storiesForThemeID:self.themeID];
    
    NSUInteger storyCounter = 0;
    
    for (NSDictionary *storyData in self.relatedStories) {
        
        CGPoint storyOrigin = CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView);
        
        StoryStubView *aStoryStub = [[StoryStubView alloc] initWithDictionary:storyData
                                                                     atOrigin:storyOrigin];
        
        aStoryStub.delegate = self;
        
        [self.scrollView addSubview:aStoryStub];
        
        self.yForNextView = CGRectGetMaxY(aStoryStub.frame) + VERTICAL_SPACER_STANDARD;
                
        storyCounter++;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    // was adding 20.0 more to the bottom, but I don't like the white space.
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SHGMapView Delegate Methods

- (SHGMapView *)storyMapView {
    
    if (!_storyMapView) {
        
        MKCoordinateRegion themeRegion = [SHG_DATA regionFromDictionary:self.themeDictionary];
        
        /*
        CGRect mapBounds;
        
        if (ON_IOS7) {
            
            mapBounds = self.view.bounds;
        } else {
         
            // adjust for status bar, which is always on top when map view is
            // presented as subview on iOS 6
            CGRect windowBounds = self.view.window.bounds;
            CGFloat statusBarHeight = 20.0;
            mapBounds = CGRectMake(windowBounds.origin.x, windowBounds.origin.y + statusBarHeight,
                                   windowBounds.size.width, windowBounds.size.height - statusBarHeight);
        }
        */
        
        _storyMapView = [[SHGMapView alloc] initWithFrame:self.view.bounds
                                                    title:NSLocalizedString(@"Stories", @"Title of stories map")
                                                   region:themeRegion
                                             navBarMargin:NO];
        _storyMapView.dataRegion = themeRegion;
        [_storyMapView showUser];
        _storyMapView.delegate = self;
    }
    
    return _storyMapView;
}

- (void)showMap {
    
    [self.storyMapView setAlpha:0.0];
    
    // add to window, rather than view, to show over-top of navbar
    [self.view.window addSubview:self.storyMapView];
    
    [UIView animateWithDuration:0.5
                     animations:^{self.storyMapView.alpha = 1.0;}
                     completion:^(BOOL finished){[self.storyMapView recenterMap];}];
    
    [self.storyMapView addAnnotations:[SHG_DATA storyMapAnnotationsForThemeID:self.themeID]];
}

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType {
    
    [UIView animateWithDuration:0.5
                     animations:^{self.storyMapView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         
                         // push if needed
                         if (itemID != NSNotFound) {
                             DLog(@"Would show story with id %lu", (unsigned long)itemID);
                             
                             [self showStoryWithID:itemID fromMap:YES];
                         }
                     }];
}

#pragma mark - Show a Story

- (void)showStoryWithID:(NSUInteger)storyID fromMap:(BOOL)fromMap {
    
    NSDictionary *storyDictionary = [SHG_DATA dictionaryForStoryID:storyID];
    
    if (storyDictionary) {
        
        NSString *flurryEvent = fromMap ? kFlurryEventStoryViewFromMap : kFlurryEventStoryView;
        
        [SHG_DATA logFlurryEventNamed:flurryEvent
                       withParameters:@{ kFlurryParamSlug : [storyDictionary objectForKey:kContentSlugKey] }];
        
        StoryViewController *storyVC = [[StoryViewController alloc] initWithNibName:nil bundle:nil];
        
        storyVC.storyData = storyDictionary;
        
        [self.navigationController pushViewController:storyVC animated:YES];
    } else {
        
        DLog(@"No story found for id %lu", (unsigned long)storyID);
    }
}

- (void)handleSelectionOfStoryStub:(StoryStubView *)storyStub withID:(NSUInteger)storyID {
    
    if (storyID != NSNotFound) {
        [self showStoryWithID:storyID fromMap:NO];
    } else {
        DLog(@"Story ID unknown");
    }
}


#pragma mark - Show sharing menu

- (void)showActivityViewController {
    
    NSString *themeString = [NSString stringWithFormat:@"I'm exploring %@ in the #%@ app",
                             [self.themeDictionary objectForKey:kContentTitleKey],
                             kAppHashTag]; // or kProjectName
    
    NSString *themeURLString = [NSString stringWithFormat:@"%@/%@",
                                kThemeURL,
                                [self.themeDictionary objectForKey:kContentSlugKey]];
    
    NSArray *activityItems = @[themeString, [NSURL URLWithString:themeURLString]];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                             applicationActivities:nil];

    activityVC.excludedActivityTypes = @[UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll];

    __weak NSString *themeSlug = [self.themeDictionary objectForKey:kContentSlugKey];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
        if (completed) {
            DLog(@"User chose %@", activityType);
            
            [SHG_DATA logFlurryEventNamed:kFlurryEventThemeShare
                           withParameters:@{ kFlurryParamSlug : themeSlug,
                                             kFlurryParamActivity : activityType }];
        }
    };

    // is this necessary for iOS 6?
    //activityVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentViewController:activityVC
                       animated:YES
                     completion:nil];
}


#pragma mark - Original Sharing methods (DEPRECATED?)

// hang on to all this stuff until you finalize this functionality on iOS 6

/*
- (void)showSharingMenu:(id)sender {
    
    if (!self.sharingMenu) {
        
        // Facebook should be iOS 6 only
        if (HAS_SOCIAL_FRAMEWORK) {
            
            // Use UIActivity instead on iOS 6?
            self.sharingMenu = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", @"Title of sharing menu")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Title of cancel button on sharing menu")
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:
                                NSLocalizedString(@"Email", @"Email button on sharing menu"),
                                NSLocalizedString(@"Send to Twitter", @"Twitter button on sharing menu"),
                                NSLocalizedString(@"Send to Facebook", @"Facebook button on sharing menu"), nil];
        } else {
            self.sharingMenu = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", @"Title of sharing menu")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Title of cancel button on sharing menu")
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:
                                NSLocalizedString(@"Email", @"Email button on sharing menu"),
                                NSLocalizedString(@"Send to Twitter", @"Twitter button on sharing menu"), nil];
        }
    }
    
    [self.sharingMenu showInView:self.view];
}

- (void)closeSharingMenu {
    
    if ([self.sharingMenu isVisible]) {
        
        [self.sharingMenu dismissWithClickedButtonIndex:-1
                                               animated:YES];
        
        // always do this?
        self.sharingMenu = nil;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
            
        case 0: {
            
            [self sendEmail];
            break;
        }
        case 1: {
            
            [self sendToTwitter];
            break;
        }
        case 2: {
            
            // currently receives cancel on iOS 5, so check again:
            if (HAS_SOCIAL_FRAMEWORK) {
            
                [self sendToFacebook];
            }
            
            break;
        }
            
        case 3: {
            DLog(@"User tapped cancel");
            break;
        }
            
        case -1: {
            DLog(@"Sharing menu dismissed automatically");
            break;
        }
            
        default: {
            
            DLog(@"Unhandled sharing menu selection: %d", buttonIndex);
            break;
        }
    }
}

- (void)sendEmail {
    
    DLog(@"Construct an email.");
    
    if ([MFMailComposeViewController canSendMail]) {  //verify that mail is configured on the device
		
		MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
		
		mailVC.mailComposeDelegate = self;
		
		//mailVC.navigationBar.tintColor = [UIColor kycGray];
		
        NSString *themeText = [self.themeDictionary objectForKey:kContentTitleKey];
        
        // add Photo?
        
		NSString *messageBody = [NSString stringWithFormat:@"I'm learning about %@ in Portland, Oregon with the Know Your City App, and I thought you might be interested. %@", themeText, kEmailFooter];
        
		[mailVC setSubject:[NSString stringWithFormat:@"%@ in Portland", themeText]];
		[mailVC setMessageBody:messageBody isHTML:NO];
		
        [self presentViewController:mailVC animated:YES completion:NULL];
		
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Not Available"
														message:@"Please configure your device to send email and try again."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}
}

// mainly for testing -- do we really need this?

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // log the results during testing
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Email result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Email result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Email result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Email result: failed");
            break;
        default:
            NSLog(@"Email result: not sent");
            break;
    }
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendToTwitter {
    
    DLog(@"Make a tweet from from the short social description of the content.");
    
    // this would use a property on the object, not be constructed here from the title
    
    NSString *themeText = [self.themeDictionary objectForKey:kContentTitleKey];
    
    NSString *messageBody = [NSString stringWithFormat:@"I'm learning about %@ in Portland, Oregon with the Know Your City App.", themeText];
    
    // this would be a permalink specific to each theme/story/tidbit
    NSURL *placeholderURL = [NSURL URLWithString:@"http://www.knowyourcity.org"];
        
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterVC setInitialText:messageBody];
        
        UIImage *themeImage = self.themeGraphic.image;
        
        if (themeImage) {
            [twitterVC addImage:themeImage];
        }
        
        [twitterVC addURL:placeholderURL];
        
        [self presentViewController:twitterVC animated:YES completion:NULL];
        
    } else {
        
        DLog(@"No Twitter. Alert user?");
    }
}


- (void)sendToFacebook {
    
    DLog(@"Make a facebook post from the full social description of the the content.");
    
    // check for login?
    
    // this would use a property on the object, not be constructed here from the title
    
    NSString *themeText = [self.themeDictionary objectForKey:kContentTitleKey];
    
    NSString *messageBody = [NSString stringWithFormat:@"I'm learning about %@ in Portland, Oregon with the Know Your City App.", themeText];
    
    // this would be a permalink specific to each theme/story/tidbit
    NSURL *placeholderURL = [NSURL URLWithString:@"http://www.knowyourcity.org"];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookVC setInitialText:messageBody];
        
        UIImage *themeImage = self.themeGraphic.image;
        
        if (themeImage) {
            [facebookVC addImage:themeImage];
        }
        
        [facebookVC addURL:placeholderURL];
        
        [self presentViewController:facebookVC animated:YES completion:NULL];
        
    } else {
        
        DLog(@"No Facebook. Alert user?");
    }
}
*/

@end
