//
//  EKEventStore+CalendarAdditions.h
//  skycal
//
//  Created by Breeze on 4/16/15.
//  Copyright (c) 2015 Kevin Broom. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface EKEventStore (CalendarAdditions)

- (EKCalendar*)calendarWithName:(NSString*)name;

@end
