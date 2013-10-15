//
//  KYCConfigurationProvider.h
//  knowYourCity
//
//  Created by Matt Blair on 2/3/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KYCSTYLE [KYCConfigurationProvider sharedInstance]

// this class has utility methods for style elements like layout, fonts, images and
// data that don't fit elsewhere

@interface KYCConfigurationProvider : NSObject


+ (KYCConfigurationProvider *)sharedInstance;

- (NSString *)imageNameForMediaType:(KYCStoryMediaType)mediaType;

@end
