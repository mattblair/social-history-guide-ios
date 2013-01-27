//
//  EWWebViewController.h
//  poetryboxes
//
//  Created by Matt Blair on 7/4/12.
//  Copyright (c) 2012 Elsewise LLC. All rights reserved.
//

// The goal of this class is to make a reusable view controller to show local or remote web content.
// It has local/remote 'about' display modes that can have different behavior than other web content.
// Intended to be compatible with iOS 4.x+, including later evolutions of VC behavior.
//
// Dependencies:
// * DLog and ON_IPAD defined in .pch or somewhere else in scope.
// * ARC-friendly Reachability class (e.g. https://github.com/tonymillion/Reachability ) which in turn requires linking to the SystemConfiguration framework
// * Images for the nav buttons in bundle: navBack.png and navForward.png or as defined in .m
//
// Future: On iPad, callers could set size using modal presentation.
// That would require this view controller to implement a protocol to ask for
// dismissal or have some other way of closing itself, and it would need a different
// implementation of the navigation controls.


#import <UIKit/UIKit.h>

@class Reachability;

typedef enum EWWebViewDisplayMode {
    EWWebViewAboutLocalMode = 0,  // loads about.html with about chrome
    EWWebViewAboutRemoteMode,
    EWWebViewLocalMode,
    EWWebViewRemoteMode,
    EWWebViewYouTubeMode, // minimizes chrome
    EWWebViewVimeoMode
} EWWebViewDisplayMode;

@interface EWWebViewController : UIViewController <UIWebViewDelegate> {
    
    Reachability *internetReach;
}

@property (nonatomic, strong) UIWebView *theWebView;

// set by calling VC before display
@property (nonatomic, copy) NSString *htmlFileOrURL;

@property (assign) EWWebViewDisplayMode displayMode;

@property (assign) BOOL alertUserOnNetworkFailure; // default NO

@property (assign) BOOL showNavButtons; // default YES

@end
