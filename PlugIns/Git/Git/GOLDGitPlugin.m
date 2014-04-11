//
//  GOLDGitPlugin.m
//  Git
//
//  Created by Christoffer Winterkvist on 25/02/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "GOLDGitPlugin.h"

@implementation GOLDGitPlugin

@synthesize plugInsController;

- (id)initWithPlugInsController:(GOLDPlugInsController *)hyperPlugInsController {
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
    NSView *mainView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,20,20)];
    CALayer *viewLayer = [CALayer layer];
    CGColorRef backgroundColor = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 0.4);
    [viewLayer setBackgroundColor:backgroundColor];
    [mainView setWantsLayer:YES];
    [mainView setLayer:viewLayer];
    return mainView;
}

- (NSView *)preferenceView
{
    NSView *preferenceView = [[NSView alloc] initWithFrame:NSMakeRect(320,200,0,0)];
    return preferenceView;
}

- (void)execute
{
	NSLog(@"%s", __FUNCTION__);
}

@end
