//
//  GuestStubView.h
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// may expand to show guest detail as modaly overlay instead of pushing a vc on the nav stack
// depends on how much information we have for each guest

@interface GuestStubView : UIView

// will use a Guest object as an initializer once Core Data settles
- (id)initWithDictionary:(NSDictionary *)guestDictionary atOrigin:(CGPoint)origin;

@end
