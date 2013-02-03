//
//  StoryStubView.h
//  knowYourCity
//
//  Created by Matt Blair on 1/23/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoryStubDelegate;

@interface StoryStubView : UIView

@property (weak, nonatomic) id <StoryStubDelegate> delegate;

// presenting view controller should pull values from the story object:
// expected keys: thumbnail, title, quote, mediaType
// it should also set the tag and delegate
- (id)initWithDictionary:(NSDictionary *)storyDictionary atOrigin:(CGPoint)origin;

@end


@protocol StoryStubDelegate <NSObject>

- (void)handleSelectionOfStoryStub:(StoryStubView *)storyStub;

@end