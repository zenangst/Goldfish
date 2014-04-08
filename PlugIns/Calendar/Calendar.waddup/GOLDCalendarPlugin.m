//
//  GOLDCalendarPlugin.m
//  Calendar.waddup
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "GOLDCalendarPlugin.h"

@implementation GOLDCalendarPlugin

@synthesize plugInsController;

- (id)initWithPlugInsController:(GOLDPlugInsController *)hyperPlugInsController {
  self = [super init];
  if (self) {
    self.plugInsController = hyperPlugInsController;
    NSLog(@"%@: loaded", [self name]);
  }
  return self;
}

- (NSString *)name {
	return @"Calendar";
}

@end
