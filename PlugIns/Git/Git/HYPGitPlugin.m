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
    NSLog(@"%@: loaded", [self name]);
	}
	return self;
}

- (NSString *)name
{
	return @"Git";
}

- (NSView *)mainView
{
  NSView *mainView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
  return mainView;
}

- (NSView *)preferenceView
{
	NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
  return preferenceView;
}

@end
