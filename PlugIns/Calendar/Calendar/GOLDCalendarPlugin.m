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

- (NSView *)mainView:(NSObject<GOLDDataEntry> *)entry
{
    NSView *mainView = [[NSView alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss ZZZZ"];

    NSTextField *summaryField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 22, 200, 17)];
    [summaryField setStringValue:entry.name];
    [summaryField setBezeled:NO];
    [summaryField setDrawsBackground:NO];
    [summaryField setEditable:NO];
    [summaryField setSelectable:NO];
    [summaryField setFont:[NSFont systemFontOfSize:13]];
    [summaryField setAutoresizingMask:NSViewWidthSizable];

    NSTextField *dateField = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 2, 200, 17)];
    [dateField setStringValue:[dateFormat stringFromDate:entry.datestamp]];
    [dateField setBezeled:NO];
    [dateField setDrawsBackground:NO];
    [dateField setEditable:NO];
    [dateField setSelectable:NO];
    [dateField setFont:[NSFont systemFontOfSize:10]];
    [dateField setAutoresizingMask:NSViewWidthSizable];

    [mainView addSubview:summaryField];
    [mainView addSubview:dateField];

    dateFormat = nil;

    return mainView;
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

@end
