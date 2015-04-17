//
//  main.m
//  skycal
//
//  Created by Breeze on 4/15/15.
//  Copyright (c) 2015 Kevin Broom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#import "EKEventStore+CalendarAdditions.h"
#import "SkyEventEntry.h"

// name of predefined calendar that the events will be added to
static NSString* calendarName = @"NASA Sky Events";

NSArray* eventEntriesFromFile(NSString* filename) {
    NSMutableArray* entries = [NSMutableArray array];

    NSError* error = nil;
    NSString* fileString = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:&error];
    NSArray* fileLines = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    NSSet* monthStringSet = [NSSet setWithArray:@[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"]];
    NSSet* dayStringSet = [NSSet setWithArray:@[@"Su", @"Mo", @"Tu", @"We", @"Th", @"Fr", @"Sa"]];

    NSPredicate* timeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9][0-9]:[0-9][0-9]"];
    NSPredicate* dayOfMonthTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-3][0-9]"];

    NSString* yearString = nil;
    NSString* monthString = nil;
    NSString* dayOfMonthString = nil;
    NSString* timeString = nil;
    NSString* titleString = nil;

    for (NSString* line in fileLines) {
        NSArray* tokens = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (tokens.count == 1) {
            yearString = [tokens firstObject];
        } else {
            tokens = [tokens filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
            for (NSString* token in tokens) {
                if ([monthStringSet containsObject:token]) {
                    monthString = token;
                } else if ([dayOfMonthTest evaluateWithObject:token]) {
                    dayOfMonthString = token;
                    titleString = nil;
                } else if ([dayStringSet containsObject:token]) {
                    continue;
                } else if ([timeTest evaluateWithObject:token]) {
                    timeString = token;
                } else { // the next tokens will be the title string
                    titleString = titleString ? [NSString stringWithFormat:@"%@ %@", titleString, token] : token;
                }
            }
            if (yearString && monthString && dayOfMonthString && titleString) {
                SkyEventEntry* entry = nil;
                if (timeString) {
                    entry = [SkyEventEntry entryWithTitle:titleString
                                               dateString:[NSString stringWithFormat:@"%@-%@-%@ %@", yearString, monthString, dayOfMonthString, timeString]
                                                   allDay:NO];
                } else {
                    entry = [SkyEventEntry entryWithTitle:titleString
                                               dateString:[NSString stringWithFormat:@"%@-%@-%@", yearString, monthString, dayOfMonthString]
                                                   allDay:YES];
                }
                [entries addObject:entry];
                dayOfMonthString = timeString = titleString = nil;
            }
        }
    }

    return entries;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // parse the data
        NSArray* eventEntries = eventEntriesFromFile(@"data.txt");

        // create event store
        EKEventStore* eventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];

        // get the Sky Events calendar
        EKCalendar* eventCalendar = [eventStore calendarWithName:calendarName];

        // create events
        NSUInteger counter = 0;
        NSError* error = nil;
        for (SkyEventEntry* entry in eventEntries) {
            EKEvent* newEvent = [EKEvent eventWithEventStore:eventStore];
            newEvent.calendar = eventCalendar;
            newEvent.title = entry.title;
            newEvent.startDate = entry.date;
            newEvent.endDate = entry.date;
            newEvent.alarms = nil;
            newEvent.allDay = entry.allDay;

            // save the event
            error = nil;
            [eventStore saveEvent:newEvent span:EKSpanThisEvent commit:NO error:&error];

            counter++;
            NSLog(@"creating entry %lu", counter);
        }

        // commit all events
        NSLog(@"saving events...");
        error = nil;
        //[eventStore commit:&error]; // uncomment to commit all added events to the calendar
        NSLog(@"...done!");
    }
    return 0;
}
