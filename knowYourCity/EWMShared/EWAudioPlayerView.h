//
//  EWAudioPlayerView.h
//  pdxPublicArt
//
//  Created by Matt Blair on 11/24/12.
//
//

// initial version of this will assume iPhone/popover width of 320 points.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EWAudioPlayerView : UIView <AVAudioPlayerDelegate>

// setters for custom images
@property (strong, nonatomic) UIImage *playButtonImage;
@property (strong, nonatomic) UIImage *pauseButtonImage;

// also add properties for slider styling, notes about background color/view

- (id)initWithAudioURL:(NSURL *)audioURL;

- (void)pausePlayback;
- (void)resumePlayback;

@end
