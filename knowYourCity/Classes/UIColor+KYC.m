//
//  UIColor+KYC.m
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "UIColor+KYC.h"

@implementation UIColor (KYC)

#pragma mark - Color Scheme

// These are wild guesses at this point

+ (UIColor *)kycBrown {
    
    return [UIColor colorWithRed:77.0/255.0 green:63.0/255.0 blue:48.0/255.0 alpha:1.0];
}

+ (UIColor *)kycGray {
    return [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
}

+ (UIColor *)kycOffWhite {
    return [UIColor colorWithRed:210.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
}

#pragma mark - Semantic Colors

+ (UIColor *)kycNavBarColor {
    return [UIColor blackColor];
}

+ (UIColor *)kycGuestBackgroundColor  {
    return [UIColor kycOffWhite];
}

@end
