//
//  GuestStubView.h
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// may expand to show guest detail as modal overlay instead of pushing a vc on the nav stack
// depends on how much information we have for each guest
// If this view shows all details, it should be initialized with a Guest NSManagedObject
// Else: implement a delegate, and tell the presenting VC to push a Guest Detail VC

@interface GuestStubView : UIView

- (id)initWithDictionary:(NSDictionary *)guestDictionary atOrigin:(CGPoint)origin;

@end
