//
//  KYCPrivateConstants.h
//  knowYourCity
//
//  Created by Matt Blair on 1/19/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// required for TestFlight SDK 1.2+
extern NSString* const kTestFlightAppToken;


// Flurry
extern NSString* const kFlurryAPIKey;

// =======================================================================

// Add a KYCPrivateConstants.m files that looks like:

// Or comment out all reference to TestFlight if not using it.
// NSString* const kTestFlightAppToken = @"appToken";

// Or comment out all references to Flurry if not using it.
// NSString* const kFlurryAPIKey = @"flurryKey";