//
//  EWAAudioPlayerView.m
//
//  Created by Matt Blair on 11/24/12.
//
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#import "EWAAudioPlayerView.h"

#define AUDIO_TIME_DEFAULT_Y 6.0
#define AUDIO_TIME_LABEL_WIDTH 28.0
#define AUDIO_TIME_LABEL_FONT_SIZE 10.0

// Based on the assumption that a clip is several minutes long, and the thumb
// might not even move every second.
#define AUDIO_DISPLAY_UPDATE_INTERVAL .5

@interface EWAAudioPlayerView ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) UILabel *currentTime;
@property (strong, nonatomic) UILabel *totalTime;
@property (strong, nonatomic) UISlider *audioScrubber;

@property (strong, nonatomic) UIButton *playButton;
//@property (strong, nonatomic) UIButton *pauseButton;

@property (strong, nonatomic) NSTimer *thumbTimer;

@end

@implementation EWAAudioPlayerView

#pragma mark - View lifecycle

- (id)initWithAudioURL:(NSURL *)audioURL {
    
    CGRect defaultFrame = CGRectMake(0.0, 0.0, 320.0, 44.0); // height was 52
    
    self = [super initWithFrame:defaultFrame];
    if (self) {
        
        self.backgroundColor = [UIColor underPageBackgroundColor];
        
        NSError *audioError = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL
                                                                  error:&audioError];
        
        // test audioError here?
        
        self.audioPlayer.delegate = self;
        
        CGRect currentFrame = CGRectMake(10.0, AUDIO_TIME_DEFAULT_Y, AUDIO_TIME_LABEL_WIDTH, 30.0);
        
        self.currentTime = [[UILabel alloc] initWithFrame:currentFrame];
        
        self.currentTime.text = @"0:00";
        self.currentTime.font = [UIFont systemFontOfSize:AUDIO_TIME_LABEL_FONT_SIZE];
        self.currentTime.backgroundColor = [UIColor clearColor];
        self.currentTime.textAlignment = UITextAlignmentCenter;
        
        [self addSubview:self.currentTime];
        
        CGRect sliderFrame = CGRectMake(42.0, 11.0, 192.0, 23.0); // y was 15
        
        self.audioScrubber = [[UISlider alloc] initWithFrame:sliderFrame];
        
        self.audioScrubber.value = 0.0;
        self.audioScrubber.maximumValue = self.audioPlayer.duration;
        
        [self.audioScrubber addTarget:self
                               action:@selector(handleScrubbing)
                     forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.audioScrubber];
        
        CGRect totalFrame = CGRectMake(240.0, AUDIO_TIME_DEFAULT_Y, AUDIO_TIME_LABEL_WIDTH, 30.0);
        
        self.totalTime = [[UILabel alloc] initWithFrame:totalFrame];
        self.totalTime.font = [UIFont systemFontOfSize:AUDIO_TIME_LABEL_FONT_SIZE];
        self.totalTime.backgroundColor = [UIColor clearColor];
        self.totalTime.textAlignment = UITextAlignmentCenter;
        
        self.totalTime.text = [NSString stringWithFormat:@"%d:%02d",
                               (int)self.audioPlayer.duration / 60, (int)self.audioPlayer.duration % 60, nil];
        
        [self addSubview:self.totalTime];
        
        //CGRect buttonFrame = CGRectMake(280.0, AUDIO_TIME_DEFAULT_Y, 30.0, 30.0);
        CGRect buttonFrame = CGRectMake(274.0, 7.0, 28.0, 28.0);
        
        self.playButton = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [self.playButton setImage:[UIImage imageNamed:PLAY_BUTTON_IMAGE]
                         forState:UIControlStateNormal];
        
        [self.playButton setImage:[UIImage imageNamed:PAUSE_BUTTON_IMAGE]
                         forState:UIControlStateSelected];
        
        [self.playButton addTarget:self
                            action:@selector(togglePlayStatus)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.playButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"WARNING: Do not use initWithFrame with this class.");
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateCurrentTimeDisplay {
    
    int current = (int)self.audioPlayer.currentTime;
    
    self.currentTime.text = [NSString stringWithFormat:@"%d:%02d", current / 60, current % 60, nil];
}

- (void)updateScrubberThumbPosition {
    
    self.audioScrubber.value = self.audioPlayer.currentTime;
}

- (void)updateThumbAndTime {
    
    NSLog(@"Current time is %g", self.audioPlayer.currentTime);
    
    [self updateCurrentTimeDisplay];
    [self updateScrubberThumbPosition];
}

#pragma mark - UISlider Styling

- (void)setMinimumTrackColor:(UIColor *)minimumTrackColor {
    
    self.audioScrubber.minimumTrackTintColor = minimumTrackColor;
}

- (void)setMaximumTrackColor:(UIColor *)maximumTrackColor {
    
    self.audioScrubber.maximumTrackTintColor = maximumTrackColor;
}

- (void)setThumbColor:(UIColor *)thumbColor {
    
    self.audioScrubber.thumbTintColor = thumbColor;
}

#pragma mark - Handling Listener Actions

- (void)togglePlayStatus {
    
    // flip the state
    if (self.audioPlayer.playing) {
        [self.audioPlayer pause];
        [self.thumbTimer invalidate];
    } else {
        [self.audioPlayer play];
        
        self.thumbTimer = [NSTimer scheduledTimerWithTimeInterval:AUDIO_DISPLAY_UPDATE_INTERVAL
                                                           target:self
                                                         selector:@selector(updateThumbAndTime)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    
    // if it's playing, switch to selected to show the pause graphic
    self.playButton.selected = self.audioPlayer.playing;
}

- (void)handleScrubbing {
    
    self.audioPlayer.currentTime = self.audioScrubber.value;
    
    [self updateCurrentTimeDisplay];
}

#pragma mark - External Control of Playback

- (void)pausePlayback {
    
    [self.audioPlayer pause];
    [self.thumbTimer invalidate];
    
    // does invalidate set to nil?
}

- (void)resumePlayback {
    
    // resume playback, or return to the start and play
    
    // should re-init timers
}


#pragma mark - AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.thumbTimer = nil;
    
    NSLog(@"AudioPlayer finished %@", flag ? @"successfully." : @"badly!");
    
    [self updateThumbAndTime];
    
    self.playButton.selected = self.audioPlayer.playing;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    NSLog(@"Audio decoding failed with error: %@", error);
    
    self.audioScrubber.value = 0;
    
    self.playButton.enabled = NO;
}

#warning -- need to handle interruptions here...

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    // freeze state
}

// iOS 4.0+, deprecated in iOS 6.0
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    
    
}

// iOS 6.0+
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    
    
}

@end
