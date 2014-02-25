//
//  HYPCalendarPlugin.m
//  Calendar.waddup
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPCalendarPlugin.h"
#import "HYPPlugInsController.h"

@implementation HYPCalendarPlugin

- (id)initWithPlugInsController:(HYPPlugInsController *)plugInsController {
	return self;
}

- (NSString *)name {
	return @"Calendar";
}

@end
