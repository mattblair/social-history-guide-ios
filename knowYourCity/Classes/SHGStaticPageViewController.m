//
//  SHGStaticPageViewController.m
//  knowYourCity
//
//  Created by Matt Blair on 10/16/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGStaticPageViewController.h"

@interface SHGStaticPageViewController ()

@property (strong, nonatomic) UILabel *appNameLabel; // deprecated

@property (strong, nonatomic) UIImageView *appNameImageView;
@property (strong, nonatomic) UILabel *appCreditLabel;
@property (strong, nonatomic) UISegmentedControl *selectionView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation SHGStaticPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _selectedSection = SHGStaticPageAbout;
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
	// Do any additional setup after loading the view.
    
    // Do we want to use title for anything?
    //self.title = NSLocalizedString(@"About", @"Name of About View Controller");
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat yForNextView = 25.0; // 70.0 if pushed on nav stack
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.closeButton.frame = CGRectMake(295.0, yForNextView, 22.0, 22.0);
    
    [self.closeButton setImage:[UIImage imageNamed:kCloseButton]
                      forState:UIControlStateNormal];
    
    [self.closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.closeButton];
    
    yForNextView = 50.0; // enough to clear the close button completely
    
    self.appNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, yForNextView, 300.0, 28.0)];
    self.appNameImageView.image = [UIImage imageNamed:kAppNameImage];
    
    [self.view addSubview:self.appNameImageView];
    
    yForNextView += self.appNameImageView.frame.size.height + 5.0;
    
    self.appCreditLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, yForNextView, 300.0, 21.0)];
    self.appCreditLabel.text = @"Brought to you by Know Your City";
    self.appCreditLabel.font = [UIFont fontWithName:kBodyFontName size:15.0];
    self.appCreditLabel.textColor = [UIColor kycGray];
    self.appCreditLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:self.appCreditLabel];
    
    yForNextView += self.appCreditLabel.frame.size.height + 5.0;
    
    // segmented control
    
    self.selectionView = [[UISegmentedControl alloc] initWithItems:@[@"About",
                                                                     @"Credits",
                                                                     @"Donate"
                                                                     ]];
    
    self.selectionView.selectedSegmentIndex = self.selectedSection;
    
    [self.selectionView addTarget:self
                           action:@selector(handleSelection:)
                 forControlEvents:UIControlEventValueChanged];
    
    self.selectionView.frame = CGRectMake(10.0, yForNextView, 300.0, 31.0);
    
    [self.view addSubview:self.selectionView];
    
    yForNextView += self.selectionView.frame.size.height + 10.0;
    
    // webview
    
    CGFloat webHeight = self.view.bounds.size.height - yForNextView;
    CGRect webFrame = CGRectMake(0.0, yForNextView, self.view.bounds.size.width, webHeight);
    
    self.webView = [[UIWebView alloc] initWithFrame:webFrame];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self loadTextForCurrentSection];
    
}

- (void)close:(id)sender {
    
    DLog(@"Would close this.");
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
}

- (void)handleSelection:(id)sender {
    
    self.selectedSection = self.selectionView.selectedSegmentIndex;
    
    [self loadTextForCurrentSection];
}

- (void)loadTextForCurrentSection {
    
    NSString *contentFilename;
    
    switch (self.selectedSection) {
        case SHGStaticPageAbout:
            contentFilename = @"about";
            break;
            
        case SHGStaticPageCredits:
            contentFilename = @"credits";
            break;
            
        case SHGStaticPageDonate:
            contentFilename = @"donate";
            break;
            
        default:
            contentFilename = @"about";
            break;
    }
    
    DLog(@"Will load %@", contentFilename);
    
    NSString *localHTMLPath = [[NSBundle mainBundle] pathForResource:contentFilename
                                                               ofType:@"html"];
	
    if (localHTMLPath) {
        NSURL *url = [NSURL fileURLWithPath:localHTMLPath];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:request];
    } else {
        DLog(@"Couldn't find %@.html in bundle.", contentFilename);
    }
}


@end
