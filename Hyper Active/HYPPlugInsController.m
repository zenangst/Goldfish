//
//  HYPPlugInsController.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPPlugInsController.h"

@implementation HYPPlugInsController

- (NSString *)hyperActiveVersion
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSUInteger)apiVersion
{
	return 1.0;
}

@end
