//
//  SHGDataController.m
//  knowYourCity
//
//  Created by Matt Blair on 10/14/13.
//  Copyright (c) 2013 Elsewise LLC. All rights reserved.
//

#import "SHGDataController.h"

#import <FMDB/FMDatabase.h>

@interface SHGDataController ()

@property (strong, nonatomic) FMDatabase *shgDatabase;

@end

@implementation SHGDataController

#pragma mark - Singleton and Init Code

+ (SHGDataController *)sharedInstance {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"shg-web"
                                                           ofType:@"sqlite"];
        
        self.shgDatabase = [FMDatabase databaseWithPath:dbPath];
        
        if (![self.shgDatabase open]) {
            
            DLog(@"Database failed");
        }
    }
    return self;
}

- (void)dealloc {
    
    if (self.shgDatabase) {
        
        if ([self.shgDatabase hasOpenResultSets]) {
            [self.shgDatabase closeOpenResultSets];
        }
        
        [self.shgDatabase close];
    }
}

#pragma mark - Themes

- (NSArray *)publishedThemes {
    
    if (!_publishedThemes) {
        
        NSMutableArray *themes = [[NSMutableArray alloc] initWithCapacity:15];
        
        FMResultSet *s = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM themes where workflow_state_id = %d;", PUBLISHED_WORKFLOW_STATE];
        
        while ([s next]) {
            
            [themes addObject:[s resultDictionary]];
            DLog(@"Theme title: %@", [s stringForColumn:kThemeTitleKey]);
        }
        
        _publishedThemes = [NSArray arrayWithArray:themes];
    }
    
    return _publishedThemes;
}

#pragma mark - Stories

- (NSArray *)storiesForThemeID:(NSUInteger)themeID {
    
    NSMutableArray *stories = [[NSMutableArray alloc] initWithCapacity:10];
    
    FMResultSet *resultSet = [self.shgDatabase executeQueryWithFormat:@"SELECT * FROM stories where theme_id = %d and workflow_state_id = %d;", themeID, PUBLISHED_WORKFLOW_STATE];

    while ([resultSet next]) {
        
        [stories addObject:[resultSet resultDictionary]];
        
    }
    
    return [NSArray arrayWithArray:stories];
}

#pragma mark - Guests



@end
