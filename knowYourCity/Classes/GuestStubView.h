//
//  GuestStubView.h
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// presenting view or vc should manage transition to full guest view

@interface GuestStubView : UIView

- (id)initWithDictionary:(NSDictionary *)guestDictionary atOrigin:(CGPoint)origin;

@end
