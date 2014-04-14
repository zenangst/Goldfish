//
//  GOLDPlugInsController.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDPlugInsLoader.h"
#import "GOLDPlugInsController.h"
#import "GOLDPlugIn.h"

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

- (void)loadConfigurationForPlugIn:(id)plugIn
{
    NSString *plugInDirectory = [self plugInDirectory:[plugIn name]];
    BOOL plugInDirectoryExists = [[NSFileManager defaultManager] fileExistsAtPath:plugInDirectory];

    if (!plugInDirectoryExists) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:plugInDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

- (void)saveConfiguration
{
    NSLog(@"%s", __FUNCTION__);
}

- (NSString *)goldfishVersion
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSUInteger)apiVersion
{
	return 1.0;
}

- (NSString *)plugInDirectory:(NSString *)bundleIdentifier
{
	NSString *path = [[[GOLDPlugInsLoader sharedLoader] applicationDirectory] relativePath];
	return [path stringByAppendingFormat:@"/%@", bundleIdentifier];
}

@end
