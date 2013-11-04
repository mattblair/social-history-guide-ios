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

// from the website's stylesheet at launch:
//$pshg-light-gray: #ccc;
//$pshg-medium-gray: #999;
//$pshg-dark-gray: #333;

+ (UIColor *)kycLightGray {
    return [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
}

+ (UIColor *)kycMediumGray {
    return [UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0];
}

+ (UIColor *)kycDarkGray {
    return [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0];
}

+ (UIColor *)kycGray {
    return [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
}

// aka #eb0000
+ (UIColor *)kycRed {
    return [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
}

+ (UIColor *)kycOffWhite {
    
    // too dark
    //return [UIColor colorWithRed:210.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0];
    
    return [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:240.0/255.0 alpha:1.0];
}

#pragma mark - Semantic Colors

+ (UIColor *)kycNavBarColor {
    return [UIColor blackColor];
}

+ (UIColor *)kycGuestBackgroundColor  {
    return [UIColor kycOffWhite];
}

@end
