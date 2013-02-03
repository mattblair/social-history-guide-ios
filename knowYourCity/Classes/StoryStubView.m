//
//  StoryStubView.m
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "StoryStubView.h"


#define STORY_STUB_WIDTH_IPHONE 300.0
#define STORY_STUB_HEIGHT_IPHONE 100.0

// iPad values TBD
#define STORY_STUB_WIDTH_IPAD 300.0
#define STORY_STUB_HEIGHT_IPAD 150.0

// are both of these square?
#define STORY_THUMBNAIL_SIZE 80.0

#define MEDIA_BUTTON_SIZE 44.0
#define MEDIA_BUTTON_Y 25.0 // or just center it vertically?

#define STORY_STUB_MARGIN 10.0

@interface StoryStubView ()

// temporary. Will be replaced by an NSManagedObject subclass.
@property (strong, nonatomic) NSDictionary *storyData;

@property (strong, nonatomic) UIImageView *thumbnailView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *quoteLabel;
@property (strong, nonatomic) UIButton *mediaButton;

@end


@implementation StoryStubView

- (id)initWithDictionary:(NSDictionary *)storyDictionary atOrigin:(CGPoint)origin {
    
    CGFloat stubWidth = ON_IPAD ? STORY_STUB_WIDTH_IPAD : STORY_STUB_WIDTH_IPHONE;
    CGFloat stubHeight = ON_IPAD ? STORY_STUB_HEIGHT_IPAD : STORY_STUB_HEIGHT_IPHONE;
    
    CGRect stubFrame = CGRectMake(origin.x, origin.y, stubWidth, stubHeight);
    
    self = [super initWithFrame:stubFrame];
    if (self) {
        
        self.storyData = storyDictionary;
        
        self.backgroundColor = [UIColor kycOffWhite];
        
        // make Thumbnail optional, and move 
        
        CGFloat textX = STORY_STUB_MARGIN;
        CGFloat textWidth = stubWidth - textX - MEDIA_BUTTON_SIZE - STORY_STUB_MARGIN;
        
        NSString *thumbnailName = [self.storyData objectForKey:@"thumbnail"];
        
        if ([thumbnailName length] > 0) {
            
            CGRect thumbnailRect = CGRectMake(STORY_STUB_MARGIN, STORY_STUB_MARGIN, STORY_THUMBNAIL_SIZE, STORY_THUMBNAIL_SIZE);
            
            self.thumbnailView = [[UIImageView alloc] initWithFrame:thumbnailRect];
            // if you use retina, init this by url with type jpg
            self.thumbnailView.image = [UIImage imageNamed:thumbnailName];
            
            [self addSubview:self.thumbnailView];
            
            // move text to the right of the thumbnail
            textX = STORY_THUMBNAIL_SIZE + STORY_STUB_MARGIN*2.0;
            textWidth = stubWidth - textX - MEDIA_BUTTON_SIZE - STORY_STUB_MARGIN;
        }
        
        // title
        CGRect nameRect = CGRectMake(textX, STORY_STUB_MARGIN, textWidth, 30.0);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:nameRect];
        self.titleLabel.text = [self.storyData objectForKey:@"title"];
        self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:18.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        
        // quote -- needs to be higher if title is 1 line
        
        CGFloat quoteY = CGRectGetMaxY(self.titleLabel.frame) + STORY_STUB_MARGIN;
        CGRect quoteRect = CGRectMake(textX, quoteY, textWidth, 50.0);
        
        self.quoteLabel = [[UILabel alloc] initWithFrame:quoteRect];
        self.quoteLabel.text = [self.storyData objectForKey:@"quote"];
        self.quoteLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
        self.quoteLabel.numberOfLines = 2;
        self.quoteLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.quoteLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.quoteLabel];
        
        // media button - enum?
        CGFloat mediaX = textX + textWidth;
        // calculate a vertically centered Y?
        CGRect mediaRect = CGRectMake(mediaX, MEDIA_BUTTON_Y, MEDIA_BUTTON_SIZE, MEDIA_BUTTON_SIZE);
        
        self.mediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        KYCStoryMediaType mediaType = KYCStoryMediaTypeAudio;
        NSString *mediaImage;
        
        NSNumber *mediaTypeNumber = [self.storyData objectForKey:@"mediaType"];
        
        if (mediaTypeNumber) {
            mediaType = [mediaTypeNumber integerValue];
        }
        
        switch (mediaType) {
            case KYCStoryMediaTypeText:
                mediaImage = @"180-stickynote";
                break;
            
            case KYCStoryMediaTypeMapPoints:
                mediaImage = @"07-map-marker";
                break;
                
            case KYCStoryMediaTypeBiography:
                mediaImage = @"145-persondot";
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
                
            default: // aka KYCStoryMediaTypeAudio
                mediaImage = @"120-headphones";
                break;
        }
        
        
        [self.mediaButton setImage:[UIImage imageNamed:mediaImage]
                          forState:UIControlStateNormal];
        
        [self.mediaButton addTarget:self
                             action:@selector(buttonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        self.mediaButton.frame = mediaRect;
        
        [self addSubview:self.mediaButton];
        
        // gesture recognizer

    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)buttonTapped:(id)sender {
    
    DLog(@"Story Button tapped.");
    
    [self.delegate handleSelectionOfStoryStub:self];
}

@end
