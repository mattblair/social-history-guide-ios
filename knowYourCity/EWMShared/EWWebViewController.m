//
//  EWWebViewController.m
//  poetryboxes
//
//  Created by Matt Blair on 7/4/12.
//  Copyright (c) 2012 Elsewise LLC. All rights reserved.
//



#import "EWWebViewController.h"

// for cancelling web requests gracefully...
#import "Reachability.h"

#define WEB_NAVIGATION_BACK @"nav-backward" // navBack
#define WEB_NAVIGATION_FORWARD @"nav-forward" // navForward

@interface EWWebViewController ()

@property (nonatomic, copy) NSString *localHTMLFileName;  
@property (nonatomic, strong) NSURL *remoteURL;

- (void)updateNavButtons;

- (void)reachabilityChanged: (NSNotification* )note;

- (void)refreshTheWebView;

- (void)loadLocalAboutPage;
- (void)loadLocalWebPage;

// service-specific handlers
- (void)displayYouTubeVideo;
- (void)displayVimeoVideo;

@end

@implementation EWWebViewController

@synthesize theWebView, htmlFileOrURL, displayMode;
@synthesize alertUserOnNetworkFailure, showNavButtons;
@synthesize localHTMLFileName, remoteURL;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.alertUserOnNetworkFailure = NO;
        self.showNavButtons = YES;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.theWebView = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    
    self.theWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.theWebView];
    
    if (self.showNavButtons) {
        
        // Set up the nav buttons -- for both iPad and iPhone
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                                [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:WEB_NAVIGATION_BACK],
                                                 [UIImage imageNamed:WEB_NAVIGATION_FORWARD],
                                                 nil]];
        
        [segmentedControl addTarget:self action:@selector(navigateWebView:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(0, 0, 90, 30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.momentary = YES;
        
        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        
        self.navigationItem.rightBarButtonItem = segmentBarItem;
        
        // hide the toolbar
        // do you need to save state? or just always restore it in callers?
        [self.navigationController setToolbarHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
	
	internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
    
    self.theWebView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self refreshTheWebView];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.theWebView stopLoading];	// in case the web view is still loading its content
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Handling Rotations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    // assumes iPad should rotate and phone should not
    return ON_IPAD ? YES : (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Handling Network Availability

-(void)reachabilityChanged:(NSNotification*)note {
    
    Reachability * reach = [note object];
    
    if([reach isReachable]) {
        
        // restart any stalled activities
        // Do you want to reload automatically? Or does this get called too often for that?
        DLog(@"Internet available.");
    }
    else {
        
        // handle unreachable
        DLog(@"Internet NOT available.");
        [self.theWebView stopLoading];
        
        [self showNoConnectionAlert];
        
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	// check reachability here for everything except the locally loaded about page
	
    // could also use isReachableViaWiFi or isReachableViaWWAN for more control
	if ([internetReach isReachable ]) { 
		return YES;
	}
	else {  // no internet connection
		
		if ([[request URL] isFileURL]) { 
			return YES;
		}
		
		else {
			
			[self showNoConnectionAlert];
			
			return NO;
		}
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self updateNavButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	DLog(@"webView request failed with error: %@", [error localizedDescription]);
	
	// Another option:
    
	// if the webview can go back, take them back?
	/*
     if (self.theWebView.canGoBack) {
     [self.theWebView goBack];
     }
     else {
     //reload 
     [self loadLocalAboutPage];
     }
     */
    
    [self.theWebView stopLoading];
    
	[self showLoadFailureWithError:error];
    
	[self updateNavButtons];
}


#pragma mark - Navigation and loading

-(void)updateNavButtons {
    
	UISegmentedControl *segControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
    
    [segControl setEnabled:self.theWebView.canGoBack forSegmentAtIndex:0];
    [segControl setEnabled:self.theWebView.canGoForward forSegmentAtIndex:1];
}

-(IBAction)navigateWebView:(id)sender {
	
	//cast and determine whether to go forward or back
	UISegmentedControl *segControl = (UISegmentedControl *)sender;
	
	if ([segControl selectedSegmentIndex] == 0) {
		//DLog(@"Tapped Back");
		[self.theWebView goBack];
	}
	else {
		//DLog(@"Tapped Forward");
		[self.theWebView goForward];
	}
}

- (void)refreshTheWebView {
    
    // Improve this bounds check
    if ([self.htmlFileOrURL length] > 8 && 
        [[self.htmlFileOrURL substringToIndex:4] isEqualToString:@"http"]) {
        
        // it's remote
        
        NSRange ytRange = [self.htmlFileOrURL rangeOfString:@"youtube.com"]; // check for youtu.be, too?
        
        if (ytRange.length > 0) {
            self.displayMode = EWWebViewYouTubeMode;
        }
        else {
            self.displayMode = EWWebViewRemoteMode;
        }
        
        self.remoteURL = [NSURL URLWithString:self.htmlFileOrURL];
        
    }
    else {
        // it's local -- test for about here...
        
        if ([self.htmlFileOrURL length] == 5 && [self.htmlFileOrURL isEqualToString:@"about"]) {
            
            self.displayMode = EWWebViewAboutLocalMode;
            
        }
        else {
            
            self.displayMode = EWWebViewLocalMode;
            
        }
        
        self.localHTMLFileName = self.htmlFileOrURL;
    }
    
    
    // load
    
    switch (self.displayMode) {
            
        case EWWebViewAboutLocalMode: {
            
            [self loadLocalAboutPage];
            
            break;
        }
            
        case EWWebViewLocalMode: { // reads a file from the bundle
            
            [self loadLocalWebPage];
            
            break;
        }
            
        case EWWebViewYouTubeMode: {
            
            [self displayYouTubeVideo];
            
            break;
        }
        
        case EWWebViewVimeoMode: {
            
            [self displayYouTubeVideo];
            
            break;
        }
            
        default: {
            
            // handle remote web page
            
            self.theWebView.scalesPageToFit = YES; // or YES?
            
            // set some default title?
            //self.navigationItem.title = @"Default Title"; // set on load?
            
            NSURLRequest *request = [NSURLRequest requestWithURL:self.remoteURL];
            
            [self.theWebView loadRequest:request];
            
            break;
            
        }
    }
}

- (void)loadLocalAboutPage {
    
    self.theWebView.scalesPageToFit = YES;
    self.navigationItem.title = @"About";
    
    // from file system
    self.localHTMLFileName = @"about";
    NSString *localAboutHTML = [[NSBundle mainBundle] pathForResource:self.localHTMLFileName 
                                                               ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:localAboutHTML];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[self.theWebView loadRequest:request];
}

- (void)loadLocalWebPage {
    
    NSString *localHTMLPath = [[NSBundle mainBundle] pathForResource:self.localHTMLFileName 
                                                              ofType:@"html"];
	
    if (localHTMLPath) {
        
        NSURL *url = [NSURL fileURLWithPath:localHTMLPath];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.theWebView loadRequest:request];
        
    }
    else {
        
        DLog(@"WebVC: Could not find local HTML file in bundle.");
                
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Resource Not Available" 
//														message:@"The resource is not currently available." 
//													   delegate:self 
//											  cancelButtonTitle:@"OK" 
//											  otherButtonTitles:nil];
//		[alert show];
    }
}

#pragma mark - Service-specific Load Methods

- (void)displayYouTubeVideo {
    
    // NOTE: As of late 2011, YouTube will not appear in simulator.
    
    // Test and reformat the url here, if needed.
    
    self.theWebView.allowsInlineMediaPlayback = YES;
    self.theWebView.mediaPlaybackRequiresUserAction = NO;
    
    // Could try to wrap it:
    // Scale the theWebView here, and then use the new frame below?
    // I've had mixed success with this. Needs more testing.
    
    /*
     NSString *youTubeEmbedTemplate = @"\
     <html><head>\
     <style type=\"text/css\">\
     body {\
     background-color: transparent;\
     color: white;\
     }\
     </style>\
     </head><body style=\"margin:0\">\
     <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
     width=\"%0.0f\" height=\"%0.0f\"></embed>\
     </body></html>";
     
     NSString *youTubeEmbedHTML = [NSString stringWithFormat:youTubeEmbedTemplate, self.remoteURL, 320.0, 200.0];
     
     NSLog(@"The youTubeEmbedHTML looks like: %@", youTubeEmbedHTML);
     
     [self.theWebView loadHTMLString:youTubeEmbedHTML baseURL:nil];
     
     */
    
    NSURLRequest *youtubeRequest = [NSURLRequest requestWithURL:self.remoteURL];
    
    [self.theWebView loadRequest:youtubeRequest];
    
}

- (void)displayVimeoVideo {
    
    DLog(@"Not implemented yet.");
}

#pragma mark - User Alerts

- (void)showNoConnectionAlert {
    
    if (self.alertUserOnNetworkFailure) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection" 
                                                        message:@"Please try again when an internet connection is available." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// This method does not abide by alertUserOnNetworkFailure, with the assumption 
// users will want to know about failures of requests they've made.
- (void)showLoadFailureWithError:(NSError *)webError {
        
    // NOTE: this message is overly broad. 
    // For an app that makes frequent use of this view controller, implement a 
    // switch based on error from delegate method. And localize.
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Page Not Found" 
                                                    message:@"Sorry, there was a problem with that link. Please try again in a few moments." 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

@end
