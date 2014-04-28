//
//  GOLDCalendarEvent.h
//  Calendar
//
//  Created by Tim Kurvers on 28/4/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLDProtocols.h"

@interface GOLDCalendarEvent : NSObject <GOLDDataEntry>

// TODO: Ask Chris whether this stuff should be aligned like this
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate   *at;
@property (nonatomic, strong) NSDate   *until;
@property (nonatomic, strong) NSString *plugIn;

// These are aliases to conform to protocol
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate   *datestamp;

@end
