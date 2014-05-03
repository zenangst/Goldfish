//
//  GOLDCalendarPlugin.m
//  Calendar
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDCalendarPlugin.h"
#import "GOLDCalendarEvent.h"

@implementation GOLDCalendarPlugin

@synthesize plugInsController, bundleIdentifier, eventStore;

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController {
    self = [super init];
    if (self) {
        self.plugInsController = aPlugInsController;
        self.eventStore = [[EKEventStore alloc] init];
        // Request permission to the calendar
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:nil];

    }
    return self;
}

- (NSString *)name {
	return @"Calendar";
}

- (NSDictionary *)color
{
    return @{
        @"red"   : @0.910f,
        @"green" : @0.537f,
        @"blue"  : @0.541f
    };
}

- (NSArray *)configurations
{
    return @[
        @{
             @"enabled": @YES
        }
    ];
}

- (NSArray *)executeWithConfiguration:(NSDictionary *)configuration
{
    NSMutableArray *entries = [[NSMutableArray alloc] init];

    NSDate *start = [NSDate dateWithNaturalLanguageString:@"last week"];
    NSDate *end   = [NSDate dateWithNaturalLanguageString:@"next week"];

    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:start
                                                                      endDate:end
                                                                    calendars:nil];

    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];

    [events enumerateObjectsUsingBlock:^(EKEvent *event, NSUInteger idx, BOOL *stop) {
        GOLDCalendarEvent *entry = [[GOLDCalendarEvent alloc] init];
        entry.title      = event.title;
        entry.startDate  = event.startDate;
        entry.endDate    = event.endDate;
        entry.plugInName = self.name;
        [entries addObject:entry];
    }];

    return [entries copy];
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

@end
