//
//  GOLDPlugInsLoader.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDAppDelegate.h"
#import "GOLDPlugInsLoader.h"
#import "GOLDPlugInsController.h"
#import "GOLDProtocols.h"
#import "NSObject+ProtocolValidation.h"

static NSString * const kGoldfishPluginProtocol = @"GOLDPlugIn";
static NSString * const kGoldfishFileExtension = @"bundle";

@implementation GOLDPlugInsLoader

@synthesize loadedPlugIns;

+ (instancetype)sharedLoader
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (void)loadPlugIns
{
    NSString *builtInplugInsPath = [[NSBundle mainBundle] builtInPlugInsPath];
    NSMutableDictionary *plugInsDictionary = [[NSMutableDictionary alloc] init];
    NSArray *builtInplugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtInplugInsPath error:nil];

	[builtInplugIns enumerateObjectsUsingBlock:^(NSString *bundlePath, NSUInteger idx, BOOL *stop) {
        NSString *fullBundlePath = [NSString stringWithFormat:@"%@/%@", builtInplugInsPath, bundlePath];
        NSBundle *bundle = [NSBundle bundleWithPath:fullBundlePath];

        if ([bundle load]) {
            Class className = [bundle principalClass];
            BOOL plugInIsValid = [className conformsToPlugInProtocol];

            if (plugInIsValid) {
                id <GOLDPlugIn> plugIn = [self initializePlugin:className
                                                 withBundleIdentifier:[bundle bundleIdentifier]];
                if (!loadedPlugIns[[plugIn name]]) {
                    plugInsDictionary[[plugIn name]] = plugIn;
                    NSLog(@"%@ -> loaded", [plugIn name]);
                }
            } else {
                NSLog(@"%@ -> failed validation", className);
            }
        }
	}];

    self.loadedPlugIns = [[NSDictionary alloc] initWithDictionary:plugInsDictionary];
    plugInsDictionary = nil;
}

- (id)initializePlugin:(Class)className withBundleIdentifier:(NSString *)bundleIdentifier
{
	id <GOLDPlugIn> plugIn = [[className alloc] initWithPlugInsController:[GOLDPlugInsController sharedPlugInsController]];
    plugIn.bundleIdentifier = bundleIdentifier;
    return plugIn;
}

- (NSURL *)applicationDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory
                                                inDomains:NSUserDomainMask] lastObject];
    NSBundle *mainBundle = [NSBundle mainBundle];
    return [appSupportURL URLByAppendingPathComponent:[[mainBundle infoDictionary] objectForKey:@"CFBundleExecutable"]];
}

@end
