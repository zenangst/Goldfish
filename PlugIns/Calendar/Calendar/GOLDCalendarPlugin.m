//
//  GOLDCalendarPlugin.m
//  Calendar
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDCalendarPlugin.h"

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
	NSLog(@"%s", __FUNCTION__);
}

@end
