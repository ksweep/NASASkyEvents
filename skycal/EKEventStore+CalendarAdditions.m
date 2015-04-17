//
//  EKEventStore+CalendarAdditions.m
//  skycal
//
//  Created by Breeze on 4/16/15.
//  Copyright (c) 2015 Kevin Broom. All rights reserved.
//

#import "EKEventStore+CalendarAdditions.h"

@implementation EKEventStore (CalendarAdditions)

- (EKCalendar*)calendarWithName:(NSString*)name {
    NSArray* calendars = [self calendarsForEntityType:EKEntityTypeEvent];
    for (EKCalendar* calendar in calendars) {
        if ([calendar.title isEqualToString:name]) {
            return calendar;
        }
    }
    return nil;
}

@end
