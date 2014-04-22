//
//  GOLDPlugInsController.h
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GOLDPlugInsController : NSObject

+ (instancetype)sharedPlugInsController;
- (void)loadConfigurationForPlugIn:(id)plugIn;
- (void)saveConfiguration;
- (NSString *)goldfishVersion;
- (NSUInteger)apiVersion;
- (NSString *)plugInDirectory:(NSString *)bundleIdentifier;

@end
