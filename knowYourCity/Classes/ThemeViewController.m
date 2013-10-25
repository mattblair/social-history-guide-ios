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
@property (strong, nonatomic) UIBarButtonItem *sharingButton;
@property (strong, nonatomic) UIImageView *themeGraphic;
@property (strong, nonatomic) UILabel *titleLabel;
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
    
    self.sharingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                       target:self
                                                                       action:@selector(showSharingMenu:)];
    
    self.navigationItem.rightBarButtonItem = self.sharingButton;
    
    
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
    
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 31.0)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [self.themeDictionary objectForKey:kContentTitleKey];
    self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:kTitleFontSize];
    
    [self.titleLabel sizeToFit];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.yForNextView = CGRectGetMaxY(self.titleLabel.frame) + VERTICAL_SPACER_STANDARD;
    
    // introduction
    
    self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_LEFT_MARGIN, self.yForNextView, DEFAULT_CONTENT_WIDTH, 70.0)];
    self.introLabel.numberOfLines = 0;
    self.introLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.introLabel.text = [self.themeDictionary objectForKey:kThemeSummaryKey];
    self.introLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
    
    [self.introLabel sizeToFit];
    
    [self.scrollView addSubview:self.introLabel];
    
    self.yForNextView = CGRectGetMaxY(self.introLabel.frame) + VERTICAL_SPACER_EXTRA;
    
    // Stories label? Does this section need to be titled?
    
    // Stories buttons (will use a UIView subclass)
    /*
    NSDictionary *storyDictionary = @{ @"thumbnail" : @"kycCCBA", @"title" : @"Fascinating Story", @"quote" : @"It was fascinating to think about.", @"mediaType" : @0};
    
    StoryStubView *storyStub = [[StoryStubView alloc] initWithDictionary:storyDictionary atOrigin:CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView)];
    
    [self.scrollView addSubview:storyStub];
    
    self.yForNextView = CGRectGetMaxY(storyStub.frame) + VERTICAL_SPACER_STANDARD;
    
    
    // no image
    NSDictionary *storyTextDictionary = @{@"title" : @"Another Fascinating Story", @"quote" : @"It was even more fascinating to think about.", @"mediaType" : @2};
    
    StoryStubView *storyTextStub = [[StoryStubView alloc] initWithDictionary:storyTextDictionary atOrigin:CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView)];
    
    [self.scrollView addSubview:storyTextStub];
    
    self.yForNextView = CGRectGetMaxY(storyTextStub.frame) + VERTICAL_SPACER_EXTRA;
    */
    
    self.relatedStories = [SHG_DATA storiesForThemeID:self.themeID];
    
    NSUInteger storyCounter = 0;
    
    for (NSDictionary *storyData in self.relatedStories) {
        
        CGPoint storyOrigin = CGPointMake(DEFAULT_LEFT_MARGIN, self.yForNextView);
        
        StoryStubView *aStoryStub = [[StoryStubView alloc] initWithDictionary:storyData
                                                                     atOrigin:storyOrigin];
        
        aStoryStub.tag = STORY_TAG_OFFSET + storyCounter;
        aStoryStub.delegate = self;
        
        [self.scrollView addSubview:aStoryStub];
        
        self.yForNextView = CGRectGetMaxY(aStoryStub.frame) + VERTICAL_SPACER_STANDARD;
                
        storyCounter++;
    }
    
    // old string based button version
    /*
    for (NSString *storyName in fakeStories) {
        
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
    */
        
    // map button
    // Do we need to test for the existence of annotations at this point?
    // or can we defer that? Do they all have mappable stories?
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.mapButton.backgroundColor = [UIColor brownColor];
    
    // will be a graphic of some kind?
    [self.mapButton setTitle:@"Map" forState:UIControlStateNormal];
    
    [self.mapButton addTarget:self
                       action:@selector(showMap)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.mapButton.frame = CGRectMake(0.0, self.yForNextView, 100.0, 44.0);
    
    [self.scrollView addSubview:self.mapButton];
    
    self.yForNextView = CGRectGetMaxY(self.mapButton.frame) + VERTICAL_SPACER_STANDARD;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    // use a define for iPad in the future
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.yForNextView + 20.0);
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self closeSharingMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SHGMapView Delegate Methods

- (SHGMapView *)storyMapView {
    
    if (!_storyMapView) {
        
        _storyMapView = [[SHGMapView alloc] initWithFrame:self.view.bounds
                                                    title:NSLocalizedString(@"Story Map", @"Title of stories map")
                                                   region:[SHG_DATA regionFromDictionary:self.themeDictionary]
                                                   footer:nil];
        _storyMapView.delegate = self;
    }
    
    return _storyMapView;
}

- (void)showMap {
    
    [self.storyMapView setAlpha:0.0];
    
    [self.view addSubview:self.storyMapView];
    
    [UIView animateWithDuration:0.5
                     animations:^{self.storyMapView.alpha = 1.0;}
                     completion:NULL];
    
    [self.storyMapView addAnnotations:[SHG_DATA storyMapAnnotationsForThemeID:self.themeID]];
}

- (void)mapView:(SHGMapView *)mapView didFinishWithSelectedID:(NSUInteger)itemID ofType:(SHGMapAnnotationType)pinType {
    
    [UIView animateWithDuration:0.5
                     animations:^{self.storyMapView.alpha = 0.0;}
                     completion:^(BOOL finished){
                         
                         // push if needed
                         if (itemID != NSNotFound) {
                             DLog(@"Would show story with id %d", itemID);
                             
                             [self showStoryWithID:itemID];
                         }
                     }];
}

#pragma mark - Show a Story

- (void)showStoryWithID:(NSUInteger)storyID {
    
    NSDictionary *storyDictionary = [SHG_DATA dictionaryForStoryID:storyID];
    
    if (storyDictionary) {
        
        StoryViewController *storyVC = [[StoryViewController alloc] initWithNibName:nil bundle:nil];
        
        storyVC.storyData = storyDictionary;
        
        [self.navigationController pushViewController:storyVC animated:YES];
    } else {
        
        DLog(@"No story found for id %d", storyID);
    }
}

- (void)handleSelectionOfStoryStub:(StoryStubView *)storyStub withID:(NSUInteger)storyID {
    
    if (storyID != NSNotFound) {
        [self showStoryWithID:storyID];
    } else {
        DLog(@"Story ID unknown");
    }
}

#pragma mark - DEPRECATED JSONish STORY DISPLAY METHODS

// old button way
- (void)handleStorySelection:(id)sender {
    
    // may be temporary, pending UIView subclass with real identifier as property
    // or use the tag as an index on an array of stories
    UIView *selectedView = (UIView *)sender;
    
    // bounds check here? tag is an NSInteger, so this could go haywire...
    NSUInteger selectedStoryIndex = selectedView.tag - STORY_TAG_OFFSET;
    
    // push a story VC for that story
    
    DLog(@"Would show story #%d", selectedStoryIndex);
    
    StoryViewController *storyVC = [[StoryViewController alloc] initWithNibName:nil bundle:nil];
    
    if (selectedStoryIndex < [self.relatedStories count]) {
        
        // inject intro text here?
        storyVC.storyData = [self.relatedStories objectAtIndex:selectedStoryIndex];
        
    } else {
        
        // sub in a bogus dictionary for now
        
        NSString *introText;
        
        switch (selectedStoryIndex) {
            case 0:
                introText = kPlaceholderTextWords36;
                break;
                
            case 1:
                introText = kPlaceholderTextWords69;
                break;
                
            case 2:
                introText = kPlaceholderTextWords102;
                break;
                
            default:
                introText = kPlaceholderTextWords204;
                break;
        }
        
        storyVC.storyData = @{@"title" : @"A Story Title", @"mainText" : introText};
    }    
    
    [self.navigationController pushViewController:storyVC animated:YES];
}

#pragma mark - Show sharing menu
// might go in a category...

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
		
		mailVC.navigationBar.tintColor = [UIColor kycGray];
		
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

@end
