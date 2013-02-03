//
//  TidbitTableViewCell.m
//  knowYourCity
//
//  Created by Matt Blair on 2/2/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "TidbitTableViewCell.h"

@implementation TidbitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
