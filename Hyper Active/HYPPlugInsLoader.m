//
//  HYPPlugInsLoader.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPPlugInsLoader.h"
#import "HYPPlugInsController.h"
#import "HYPPlugIn.h"

static NSString * const kHyperFileExtension = @"bundle";

@implementation HYPPlugInsLoader

@synthesize loadedPlugIns;

- (void)loadPlugIns
{
  NSString *builtInPluginsPath = [[NSBundle mainBundle] builtInPlugInsPath];
  NSMutableArray *plugInsArray = [[NSMutableArray alloc] init];
  NSArray *builtInPlugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtInPluginsPath error:nil];
  NSBundle *bundle;
  Class plugInClassName;
  NSObject <HYPPlugIn> *plugIn;
  NSString *bundlePath;

  for (NSString *filename in builtInPlugIns) {
    bundlePath = [NSString stringWithFormat:@"%@/%@", builtInPluginsPath, filename];
    bundle = [NSBundle bundleWithPath:bundlePath];
    if ([bundle load]) {
      plugInClassName = [bundle principalClass];
      plugIn = [[plugInClassName alloc] initWithPlugInsController:[HYPPlugInsController sharedPlugInsController]];
      [plugInsArray addObject:plugIn];
    }
  }

  if (self.loadedPlugIns) {
    self.loadedPlugIns = nil;
  }
  self.loadedPlugIns = [[NSSet alloc] initWithArray:plugInsArray];
  plugInsArray = nil;
}

- (void)configurePlugIns
{
  NSWindow *mainWindow = [[NSApplication sharedApplication] mainWindow];
  for (NSObject <HYPPlugIn> *plugIn in self.loadedPlugIns) {
  	if ([plugIn respondsToSelector:@selector(mainView)]) {
    	[[mainWindow contentView] addSubview:[plugIn mainView]];
  	}
  }
}

- (void)runPlugIns
{
  
}

- (NSURL *)applicationDirectory
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
  return [appSupportURL URLByAppendingPathComponent:@"com.zenangst.Keyboard_Cowboy_2"];
}

@end
