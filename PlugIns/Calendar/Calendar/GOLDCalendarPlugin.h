//
//  GOLDCalendarPlugin.h
//  Calendar
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <EventKit/EventKit.h>
#import "GOLDPlugInsController.h"
#import "GOLDProtocols.h"

@interface GOLDCalendarPlugin : NSObject <GOLDPlugIn>

@property (nonatomic, retain) GOLDPlugInsController *plugInsController;
@property (nonatomic, retain) NSString *bundleIdentifier;
@property (nonatomic, retain) NSArray *dataCache;
@property (nonatomic, retain) EKEventStore *eventStore;

- (id)initWithPlugInsController:(GOLDPlugInsController *)aPlugInsController;
- (NSString *)name;
- (NSArray *)configurations;
- (void)executeWithConfiguration:(NSDictionary *)configuration;

@end
