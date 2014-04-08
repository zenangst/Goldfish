//
//  GOLDPlugInsController.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "GOLDPlugInsController.h"

@implementation GOLDPlugInsController

+ (instancetype)sharedPlugInsController
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)goldfishVersion
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSUInteger)apiVersion
{
	return 1.0;
}

@end
