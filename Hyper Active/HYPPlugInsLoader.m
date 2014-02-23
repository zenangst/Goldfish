//
//  HYPPlugInsLoader.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPPlugInsLoader.h"
#import "HYPPlugInsController.h"

@implementation HYPPlugInsLoader

@synthesize loadedPlugins;

+ (instancetype)sharedLoader
{
   static id sharedInstance = nil;

   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });

   return sharedInstance;
}

- (void)loadPlugins
{
	NSArray *plugins;
	plugins = [[NSFileManager sharedManager] contentsOfDirectoryAtPath:[self applicationDirectory] error:nil];
	if (plugins) {
	  NSMutableSet *mutableSet;
		for (NSString *filename in plugins) {
			if ([[NSFileManager sharedManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", [self applicationDirectory], filename]]) {
			  // TODO Create new instance of HYPPlugInsController and add it to self.loadedPlugins
			}
		}
	}
}

- (NSURL *)applicationDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
  return [appSupportURL URLByAppendingPathComponent:@"com.zenangst.Keyboard_Cowboy_2"];
}

@end
