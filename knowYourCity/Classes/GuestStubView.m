//
//  GuestStubView.m
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "GuestStubView.h"

#define GUEST_STUB_WIDTH_IPHONE 320.0
#define GUEST_STUB_HEIGHT_IPHONE 90.0

// iPad values TBD
#define GUEST_STUB_WIDTH_IPAD 300.0
#define GUEST_STUB_HEIGHT_IPAD 150.0

#define GUEST_THUMBNAIL_WIDTH 120.0
#define GUEST_THUMBNAIL_HEIGHT 90.0

#define GUEST_STUB_MARGIN 5.0 // was 10.0

@interface GuestStubView ()

// temporary. Will be replaced by an NSManagedObject subclass.
@property (strong, nonatomic) NSDictionary *guestData;

@property (strong, nonatomic) UIImageView *thumbnailView;
@property (strong, nonatomic) UILabel *toldLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *titleLabel; // or tagline or ?

@end

@implementation GuestStubView

- (id)initWithDictionary:(NSDictionary *)guestDictionary atOrigin:(CGPoint)origin {
    
    CGFloat stubWidth = ON_IPAD ? GUEST_STUB_WIDTH_IPAD : GUEST_STUB_WIDTH_IPHONE;
    CGFloat stubHeight = ON_IPAD ? GUEST_STUB_HEIGHT_IPAD : GUEST_STUB_HEIGHT_IPHONE;
    
    CGRect stubFrame = CGRectMake(origin.x, origin.y, stubWidth, stubHeight);
    
    self = [super initWithFrame:stubFrame];
    if (self) {
        
        self.guestData = guestDictionary;
        
        self.backgroundColor = [UIColor kycOffWhite];
        
        CGFloat textX = GUEST_STUB_MARGIN;
        CGFloat textWidth = stubWidth - textX - GUEST_STUB_MARGIN;
        
        // thumbnail -- nil check, because some are missing
        
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [self.guestData objectForKey:kGuestImageKey]];
        
        // we don't have high-res for most of these, do don't worry about Retina
        UIImage *guestImage = [UIImage imageNamed:imageName];
        
        if (guestImage) {
            
            CGRect thumbnailRect = CGRectMake(0.0, 0.0, GUEST_THUMBNAIL_WIDTH, GUEST_THUMBNAIL_HEIGHT);
            
            self.thumbnailView = [[UIImageView alloc] initWithFrame:thumbnailRect];
            
            self.thumbnailView.image = guestImage;
            
            [self addSubview:self.thumbnailView];
            
            // move text over to make space for the image
            textX = GUEST_THUMBNAIL_WIDTH + GUEST_STUB_MARGIN;
            textWidth = stubWidth - textX - GUEST_STUB_MARGIN;
        }
        
        // Guest Label
        self.toldLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 0.0,
                                                                   DEFAULT_CONTENT_WIDTH, 20.0)];
        self.toldLabel.numberOfLines = 1;
        self.toldLabel.text = NSLocalizedString(@"As Told By", @"Heading label for the Guest section of Story View Controller");
        self.toldLabel.font = [UIFont fontWithName:kTitleFontName size:kBodyFontSize];
        
        [self addSubview:self.toldLabel];
        
        CGFloat nameY = CGRectGetMaxY(self.toldLabel.frame) + 2.0; // GUEST_STUB_MARGIN seems to big?
        
        CGRect nameRect = CGRectMake(textX, nameY, textWidth, 25.0);
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameRect];
        self.nameLabel.text = [self.guestData objectForKey:kGuestNameKey];
        self.nameLabel.textColor = [UIColor kycRed];
        self.nameLabel.font = [UIFont fontWithName:kTitleFontName size:kSectionTitleFontSize];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        [self.nameLabel sizeToFit];
        
        [self addSubview:self.nameLabel];
        
        
        CGFloat titleY = CGRectGetMaxY(self.nameLabel.frame) + GUEST_STUB_MARGIN;
        CGRect titleRect = CGRectMake(textX, titleY, textWidth, 50.0);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        self.titleLabel.text = [self.guestData objectForKey:kGuestTitleKey];
        self.titleLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.titleLabel sizeToFit];
        
        [self addSubview:self.titleLabel];
        
        // gesture recognizer to expand to full view
        
    }
    return self;
}


@end
