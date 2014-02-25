//
//  HYPGitPlugin.m
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "HYPGitPlugin.h"

@implementation HYPGitPlugin

@synthesize plugInsController;

- (id)initWithPlugInsController:(HYPPlugInsController *)hyperPlugInsController {
  self = [super init];
	if (self) {
		self.plugInsController = hyperPlugInsController;
	}
	return self;
}

- (NSString *)name
{
	return @"Git";
}

@end
