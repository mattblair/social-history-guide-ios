//
//  SHGStaticPageViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 10/16/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SHGStaticPage) {
    SHGStaticPageAbout = 0,
    SHGStaticPageCredits,
    SHGStaticPageDonate
};

@interface SHGStaticPageViewController : UIViewController

// expose so presenting VC may link directly to any section
@property (nonatomic) SHGStaticPage selectedSection;

@end
