//
//  KYCConfigurationProvider.m
//  knowYourCity
//
//  Created by Matt Blair on 2/3/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "KYCConfigurationProvider.h"

@interface KYCConfigurationProvider ()

@end

@implementation KYCConfigurationProvider


#pragma mark - Setup

+ (KYCConfigurationProvider *)sharedInstance {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}


- (NSString *)imageNameForMediaType:(KYCStoryMediaType)mediaType {
    
    NSString *mediaImage;
    
    switch (mediaType) {
            
        case KYCStoryMediaTypeAudio:
            mediaImage = @"120-headphones";
            break;
            
        case KYCStoryMediaTypeText:
            mediaImage = @"180-stickynote";
            break;
            
        case KYCStoryMediaTypeMapPoints:
            mediaImage = @"07-map-marker";
            break;
            
        case KYCStoryMediaTypeBiography:
            mediaImage = @"111-user";
            break;
            
        case KYCStoryMediaTypeQuote:
            mediaImage = @"145-persondot"; // or 08-chat
            break;
            
        case KYCStoryMediaTypePhotoAndText:
            mediaImage = @"41-picture-frame";
            break;
            
        case KYCStoryMediaTypeAudioText:
        case KYCStoryMediaTypePhotoAndCaption: {
            
            mediaImage = @"120-headphones";
            DLog(@"WARNING: Not implemented yet.");
            break;
        }
            
        case KYCStoryMediaTypeMapComplex:
        case KYCStoryMediaTypeMapOverlay:
        case KYCStoryMediaTypeVideo: {
            
            mediaImage = @"120-headphones";
            DLog(@"WARNING: Media type %d may not be implemented until version 1.1 or later.", mediaType);
            break;
        }
            
        default:
            // throw an assertion here?
            DLog(@"WARNING: Media type %d is unknown.", mediaType);
            break;
    }
    
    
    return mediaImage;
}


@end
