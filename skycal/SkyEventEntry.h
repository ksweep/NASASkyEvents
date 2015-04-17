//
//  SkyEventEntry.h
//  skycal
//
//  Created by Breeze on 4/16/15.
//  Copyright (c) 2015 Kevin Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkyEventEntry : NSObject

- (instancetype)initWithTitleString:(NSString*)titleString dateString:(NSString*)dateString allDay:(BOOL)allDay;
+ (instancetype)entryWithTitle:(NSString*)titleString dateString:(NSString*)dateString allDay:(BOOL)allDay;

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSDate* date;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) NSDateFormatter* allDayDateFormatter;
@property (nonatomic, readonly) BOOL allDay;

@end
