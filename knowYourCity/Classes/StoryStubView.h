//
//  StoryStubView.h
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

// Created as a view to avoid the limitations of UITableView and its components.
// If no special features/behaviors are required, a table view might be simpler.

#import <UIKit/UIKit.h>

@protocol StoryStubDelegate;

@interface StoryStubView : UIView

@property (weak, nonatomic) id <StoryStubDelegate> delegate;

// presenting view controller should pull values from the story object:
// expected keys: thumbnail, title, quote, mediaType
// it should also set the delegate
- (id)initWithDictionary:(NSDictionary *)storyDictionary atOrigin:(CGPoint)origin;

@end


@protocol StoryStubDelegate <NSObject>

- (void)handleSelectionOfStoryStub:(StoryStubView *)storyStub withID:(NSUInteger)storyID;

@end