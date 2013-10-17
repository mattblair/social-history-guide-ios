//
//  TidbitTableViewCell.m
//  knowYourCity
//
//  Created by Matt Blair on 2/2/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "TidbitTableViewCell.h"

#define MEDIA_BUTTON_SIZE 22.0
#define MEDIA_BUTTON_Y 25.0
#define TIDBIT_CELL_MARGIN 5.0

@interface TidbitTableViewCell ()

// or a button?
@property (strong, nonatomic) UIImageView *mediaImageView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *themeLabel;

@property (strong, nonatomic) UILabel *yearLabel;

// action button
@property (strong, nonatomic) UIButton *selectionButton;

@end

@implementation TidbitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat textX = 50.0;
        //CGFloat textWidth = self.frame.size.width - textX - MEDIA_BUTTON_SIZE - TIDBIT_CELL_MARGIN*3.0;
        CGFloat textWidth = 210.0;
        
        // media
        
        CGRect mediaRect = CGRectMake(10.0, MEDIA_BUTTON_Y, MEDIA_BUTTON_SIZE, MEDIA_BUTTON_SIZE);
        
        self.mediaImageView = [[UIImageView alloc] initWithFrame:mediaRect];
        
        NSString *mediaImage = [KYCSTYLE imageNameForMediaType:KYCStoryMediaTypePhotoInterview];
        
        self.mediaImageView.image = [UIImage imageNamed:mediaImage];
                
        [self addSubview:self.mediaImageView];
        
        // title
        CGRect titleRect = CGRectMake(textX, TIDBIT_CELL_MARGIN, textWidth, 42.0);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        self.titleLabel.text = @"placeholder";
        self.titleLabel.font = [UIFont fontWithName:kTitleFontName size:18.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        
        // theme -- should be one line
        
        //CGFloat themeY = CGRectGetMaxY(self.titleLabel.frame) + TIDBIT_CELL_MARGIN;
        //CGFloat themeY = CGRectGetMaxY(self.titleLabel.frame);
        
        CGRect themeRect = CGRectMake(textX, 50.0, textWidth, 15.0);
        
        self.themeLabel = [[UILabel alloc] initWithFrame:themeRect];
        self.themeLabel.text = @"Theme";
        self.themeLabel.font = [UIFont fontWithName:kBodyFontName size:14.0];
        self.themeLabel.textColor = [UIColor kycGray];
        self.themeLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.themeLabel];
        
        // what else?
        
        // action button?
        //self.selectionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        // this is the reported size before of UIButtonTypeInfoDark
        //self.selectionButton.frame = CGRectMake(280.0, 23.0, 18.0, 19.0);
        //[self addSubview:self.selectionButton];
        
        // title
        CGRect yearRect = CGRectMake(260.0, 20.0, 45.0, 20.0);
        
        self.yearLabel = [[UILabel alloc] initWithFrame:yearRect];
        self.yearLabel.text = @"1972";
        self.yearLabel.font = [UIFont fontWithName:kItalicFontName size:18.0];
        self.yearLabel.textAlignment = NSTextAlignmentCenter;
        self.yearLabel.textColor = [UIColor whiteColor];
        self.yearLabel.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.yearLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithDictionary:(NSDictionary *)tidbitDictionary {
    
    self.titleLabel.text = [tidbitDictionary objectForKey:@"title"];
    self.themeLabel.text = [tidbitDictionary objectForKey:@"theme"];
    
    NSNumber *yearNumber = [tidbitDictionary objectForKey:@"year"];
    if (yearNumber) {
        self.yearLabel.text = [yearNumber stringValue];
    } else {
        self.yearLabel.hidden = YES;
    }
    
    NSNumber *mediaTypeNumber = [tidbitDictionary objectForKey:@"mediaType"];
    KYCStoryMediaType mediaType = mediaTypeNumber ? [mediaTypeNumber unsignedIntegerValue] : KYCStoryMediaTypePhotoInterview;
    self.mediaImageView.image = [UIImage imageNamed:[KYCSTYLE imageNameForMediaType:mediaType]];
}


@end
