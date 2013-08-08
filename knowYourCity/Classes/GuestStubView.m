//
//  GuestStubView.m
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "GuestStubView.h"

#define GUEST_STUB_WIDTH_IPHONE 300.0
#define GUEST_STUB_HEIGHT_IPHONE 100.0

// iPad values TBD
#define GUEST_STUB_WIDTH_IPAD 300.0
#define GUEST_STUB_HEIGHT_IPAD 150.0

// square?
#define GUEST_THUMBNAIL_SIZE 80.0

#define GUEST_STUB_MARGIN 10.0

@interface GuestStubView ()

// temporary. Will be replaced by an NSManagedObject subclass.
@property (strong, nonatomic) NSDictionary *guestData;

@property (strong, nonatomic) UIImageView *thumbnailView;
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
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        // thumbnail
        
        CGRect thumbnailRect = CGRectMake(GUEST_STUB_MARGIN, GUEST_STUB_MARGIN, GUEST_THUMBNAIL_SIZE, GUEST_THUMBNAIL_SIZE);
        
        self.thumbnailView = [[UIImageView alloc] initWithFrame:thumbnailRect];
        // if you use retina, init this by url with type jpg
        self.thumbnailView.image = [UIImage imageNamed:@"jan-dilg-temp.jpg"]; //guest_placeholder.jpg
        
        [self addSubview:self.thumbnailView];
        
        // name
        
        CGFloat textX = GUEST_THUMBNAIL_SIZE + GUEST_STUB_MARGIN*2.0;
        CGFloat textWidth = stubWidth - textX - GUEST_STUB_MARGIN;
        
        CGRect nameRect = CGRectMake(textX, GUEST_STUB_MARGIN, textWidth, 30.0);
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameRect];
        self.nameLabel.text = [self.guestData objectForKey:@"name"];
        self.nameLabel.font = [UIFont fontWithName:kTitleFontName size:18.0];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.nameLabel];
        
        // title
        
        CGFloat titleY = CGRectGetMaxY(self.nameLabel.frame) + GUEST_STUB_MARGIN;
        CGRect titleRect = CGRectMake(textX, titleY, textWidth, 50.0);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        self.titleLabel.text = [self.guestData objectForKey:@"title"];
        self.titleLabel.font = [UIFont fontWithName:kBodyFontName size:kBodyFontSize];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        
        // gesture recognizer
        
    }
    return self;
}


@end
