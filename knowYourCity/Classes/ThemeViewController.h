//
//  ThemeViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeViewController : UIViewController <UIActionSheetDelegate>

// temporary, for prototyping pending Core Data
// will be replaced by an NSManagedObject subclass called Theme
@property (strong, nonatomic) NSDictionary *themeDictionary;

@end
