//
//  GOLDCalendarEvent.m
//  Calendar
//
//  Created by Tim Kurvers on 28/4/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDCalendarEvent.h"

@implementation GOLDCalendarEvent

- (NSString *)name
{
    return self.title;
}

- (NSDate *)datestamp
{
    return self.at;
}

@end
