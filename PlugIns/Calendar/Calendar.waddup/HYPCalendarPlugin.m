//
//  HYPCalendarPlugin.m
//  Calendar.waddup
//
//  Created by Christoffer Winterkvist on 23/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPCalendarPlugin.h"

@implementation HYPCalendarPlugin

@synthesize plugInsController;

- (id)initWithPlugInsController:(HYPPlugInsController *)hyperPlugInsController {
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
