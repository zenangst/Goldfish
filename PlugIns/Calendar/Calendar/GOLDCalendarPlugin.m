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

@synthesize plugInsController, bundleIdentifier;

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController {
    self = [super init];
    if (self) {
        self.plugInsController = aPlugInsController;
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

- (NSString *)name {
	return @"Calendar";
}

- (NSArray *)configurations
{
    return @[
        @{
             @"enabled": @YES
        }
    ];
}

- (void)executeWithConfiguration:(NSDictionary *)configuration
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
        entry.title  = event.title;
        entry.at     = event.startDate;
        entry.until  = event.endDate;
        entry.plugIn = self.name;
        [entries addObject:entry];
    }];

    events = nil;

    self.dataCache = [entries copy];
    entries = nil;
}

@end
