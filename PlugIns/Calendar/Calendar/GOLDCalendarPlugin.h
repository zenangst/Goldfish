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
@property (nonatomic, retain) EKEventStore *eventStore;

@end
