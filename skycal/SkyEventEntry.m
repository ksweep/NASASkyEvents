//
//  SkyEventEntry.m
//  skycal
//
//  Created by Breeze on 4/16/15.
//  Copyright (c) 2015 Kevin Broom. All rights reserved.
//

#import "SkyEventEntry.h"

@implementation SkyEventEntry

+ (instancetype)entryWithTitle:(NSString*)titleString dateString:(NSString*)dateString allDay:(BOOL)allDay {
    return [[self alloc] initWithTitleString:titleString dateString:dateString allDay:allDay];
}

- (instancetype)initWithTitleString:(NSString*)titleString dateString:(NSString*)dateString allDay:(BOOL)allDay {
    self = [super init];
    if (self) {
        _title = titleString;
        NSDateFormatter* dateFormatter = allDay ? self.allDayDateFormatter : self.dateFormatter;
        _date = [dateFormatter dateFromString:dateString];
        _allDay = allDay;
    }
    return self;
}

- (NSDateFormatter*)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    return _dateFormatter;
}

- (NSDateFormatter*)allDayDateFormatter {
    if (!_allDayDateFormatter) {
        _allDayDateFormatter = [[NSDateFormatter alloc] init];
        [_allDayDateFormatter setDateFormat:@"yyyy-MMM-dd"];
        [_allDayDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return _allDayDateFormatter;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@, %@", _date, _title];
}

@end
