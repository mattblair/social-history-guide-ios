//
//  StoryStubView.m
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "StoryStubView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define STORY_STUB_WIDTH_IPHONE 300.0
#define STORY_STUB_HEIGHT_IPHONE 120.0

// iPad values TBD
#define STORY_STUB_WIDTH_IPAD 300.0
#define STORY_STUB_HEIGHT_IPAD 150.0

// DEPRECATED
#define STORY_THUMBNAIL_SIZE 80.0

// replaces STORY_THUMBNAIL_SIZE
#define STORY_THUMBNAIL_WIDTH 80.0
#define STORY_THUMBNAIL_HEIGHT 60.0

#define MEDIA_BUTTON_SIZE 44.0
#define MEDIA_BUTTON_Y 25.0 // or just center it vertically?

#define STORY_STUB_MARGIN 10.0

// DEPRECATED?
#define SHOW_MEDIA_TYPE_ICON NO

@interface StoryStubView ()

@property (strong, nonatomic) NSDictionary *storyData;

@property (strong, nonatomic) UIImageView *thumbnailView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

// probably deprecated
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
        self.userInteractionEnabled = YES;
        
        CGFloat textX = STORY_STUB_MARGIN;
        
        CGFloat textWidth = stubWidth - textX;
        
        if (SHOW_MEDIA_TYPE_ICON) {
            textWidth = stubWidth - textX - MEDIA_BUTTON_SIZE - STORY_STUB_MARGIN;
        }
        
        NSString *thumbnailName = [self.storyData objectForKey:kStoryImageKey];
        
        if ([thumbnailName length] > 0) {
            
            CGRect thumbnailRect = CGRectMake(STORY_STUB_MARGIN, STORY_STUB_MARGIN, STORY_THUMBNAIL_WIDTH, STORY_THUMBNAIL_HEIGHT);
            
            self.thumbnailView = [[UIImageView alloc] initWithFrame:thumbnailRect];
            
            // retina or thumbnail-specific url?
            [self.thumbnailView setImageWithURL:[SHG_DATA urlForPhotoNamed:thumbnailName]
                               placeholderImage:[SHG_DATA photoPlaceholder]];
            
            [self addSubview:self.thumbnailView];
            
            // move text to the right of the thumbnail
            textX = STORY_THUMBNAIL_WIDTH + STORY_STUB_MARGIN*2.0;
            
            if (SHOW_MEDIA_TYPE_ICON) {
                textWidth = stubWidth - textX - MEDIA_BUTTON_SIZE - STORY_STUB_MARGIN;
            } else {
                textWidth = stubWidth - textX - STORY_STUB_MARGIN;
            }
        }
        
        // title
        CGRect nameRect = CGRectMake(textX, STORY_STUB_MARGIN-5.0, textWidth, 50.0);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:nameRect];
        self.titleLabel.text = [self.storyData objectForKey:kContentTitleKey];
        self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:16.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 0;
        
        // NOTE: Several NSString sizing methods are deprecated in iOS 7.0, including:
        // sizeWithFont:constrainedToSize:lineBreakMode:
        // In iOS 7+, use sizeWithAttributes, and UITextAttributeFont, etc.?
        // or boundingRectWithSize:options:attributes:context:
        
        CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                            constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)
                                                lineBreakMode:NSLineBreakByWordWrapping];
        
        self.titleLabel.frame = CGRectMake(textX, STORY_STUB_MARGIN-5.0, textWidth, titleSize.height);
        
        [self addSubview:self.titleLabel];
        
        // subtitle -- should this be changed to wrap under thumbnail?
        
        CGFloat subtitleY = CGRectGetMaxY(self.titleLabel.frame) + STORY_STUB_MARGIN;
        CGRect subtitleRect = CGRectMake(textX, subtitleY, textWidth, 60.0);
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:subtitleRect];
        self.subtitleLabel.text = [self.storyData objectForKey:kContentSubtitleKey];
        self.subtitleLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
        self.subtitleLabel.numberOfLines = 3;
        self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        
        CGSize subtitleSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                                  constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)
                                                      lineBreakMode:NSLineBreakByWordWrapping];
        
        self.subtitleLabel.frame = CGRectMake(textX, subtitleY, textWidth, subtitleSize.height);
        
        [self addSubview:self.subtitleLabel];
        
        // media button -- probably deprecated, because they are almost all the same
        
        if (SHOW_MEDIA_TYPE_ICON) {
        
            CGFloat mediaX = textX + textWidth;
            // calculate a vertically centered Y?
            
            CGRect mediaRect = CGRectMake(mediaX, MEDIA_BUTTON_Y, MEDIA_BUTTON_SIZE, MEDIA_BUTTON_SIZE);
            
            self.mediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            NSNumber *mediaTypeNumber = [self.storyData objectForKey:@"mediaType"];
            KYCStoryMediaType mediaType = mediaTypeNumber ? [mediaTypeNumber unsignedIntegerValue] : KYCStoryMediaTypePhotoInterview;
            NSString *mediaImage = [KYCSTYLE imageNameForMediaType:mediaType];
            
            [self.mediaButton setImage:[UIImage imageNamed:mediaImage]
                              forState:UIControlStateNormal];
            
            [self.mediaButton addTarget:self
                                 action:@selector(storyTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            self.mediaButton.frame = mediaRect;
            
            [self addSubview:self.mediaButton];
            
        }
        
        UITapGestureRecognizer *storyTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(storyTapped:)];
        
        [self addGestureRecognizer:storyTap];
        
        // adjust height? or does variable height look wonky?
        
        CGFloat lowestY = MAX(CGRectGetMaxY(self.thumbnailView.frame), CGRectGetMaxY(self.subtitleLabel.frame));
        CGFloat stubHeight = lowestY + STORY_STUB_MARGIN;
        CGRect defaultFrame = self.frame;
        self.frame = CGRectMake(defaultFrame.origin.x, defaultFrame.origin.y,
                                defaultFrame.size.width, stubHeight);
    }
    
    return self;
}

- (void)storyTapped:(id)sender {
    
    DLog(@"Story tapped.");
    
    NSNumber *storyIDNumber = [self.storyData objectForKey:kStoryIDKey];
    
    NSUInteger storyID = storyIDNumber ? [storyIDNumber unsignedIntegerValue] : NSNotFound;
    
    [self.delegate handleSelectionOfStoryStub:self withID:storyID];
}

@end
