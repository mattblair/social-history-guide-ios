//
//  TidbitListViewController.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TidbitListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// received from HomeVC until Core Data is configured
// at that point, fetch directly from data manager
@property (strong, nonatomic) NSArray *tidbitList;

@end
