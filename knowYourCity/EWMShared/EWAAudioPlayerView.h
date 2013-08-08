//
//  EWAAudioPlayerView.h
//
//  Created by Matt Blair on 11/24/12.
//
//

// initial version of this will assume iPhone/popover width of 320 points.
// As of 130127: primary development will happen in KYC, then share elsewher

// current layout expects a @1x image of 7 x 14
#define PLAY_BUTTON_IMAGE @"play-audio"
#define PAUSE_BUTTON_IMAGE @"pause-audio"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EWAAudioPlayerView : UIView <AVAudioPlayerDelegate>

// setters for custom images
@property (strong, nonatomic) UIImage *playButtonImage;
@property (strong, nonatomic) UIImage *pauseButtonImage;

// slider styling

// note: setting color removes custom images
@property (strong, nonatomic) UIColor *minimumTrackColor;
@property (strong, nonatomic) UIColor *maximumTrackColor;
@property (strong, nonatomic) UIColor *thumbColor;

// provide image setters for:
// setMinimumTrackImage:forState:
// setMaximumTrackImage:forState:
// setThumbTrackImage:forState:

// add notes about background color/view

- (id)initWithAudioURL:(NSURL *)audioURL;

- (void)pausePlayback;
- (void)resumePlayback;

@end
